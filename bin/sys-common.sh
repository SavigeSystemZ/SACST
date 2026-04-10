#!/usr/bin/env bash
set -Eeuo pipefail

SYS_AGENT_ROOT="${SYS_AGENT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SYS_AGENT_PROJECTS_ROOT="${SYS_AGENT_PROJECTS_ROOT:-$HOME/.MyAdminZ}"

sys_root() {
  printf '%s\n' "$SYS_AGENT_ROOT"
}

timestamp_utc() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

timestamp_compact() {
  date -u +%Y%m%dT%H%M%SZ
}

die() {
  echo "Error: $*" >&2
  exit 1
}

warn() {
  echo "WARN: $*" >&2
}

realpath_safe() {
  python3 - "$1" <<'PY'
import os
import sys
print(os.path.abspath(sys.argv[1]))
PY
}

resolve_project_arg() {
  local arg="$1"
  if [[ "$arg" == */* ]] || [[ "$arg" == ./* ]] || [[ "$arg" == /* ]]; then
    realpath_safe "$arg"
  else
    printf '%s\n' "$SYS_AGENT_PROJECTS_ROOT/$arg"
  fi
}

ensure_project_outside_template() {
  local project_root template_root
  project_root="$(realpath_safe "$1")"
  template_root="$(realpath_safe "$SYS_AGENT_ROOT")"
  if [[ "$project_root" == "$template_root"* ]]; then
    die "project path must live outside SACST: $project_root"
  fi
}

yaml_scalar() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    $1 == key ":" {
      sub(/^[^:]+:[[:space:]]*/, "", $0)
      gsub(/^"/, "", $0)
      gsub(/"$/, "", $0)
      print
      exit
    }
  ' "$file"
}

yaml_bool() {
  local file="$1"
  local key="$2"
  yaml_scalar "$file" "$key" | tr '[:upper:]' '[:lower:]'
}

template_version() {
  yaml_scalar "$SYS_AGENT_ROOT/meta/TEMPLATE_VERSION.yaml" template_version
}

git_default() {
  yaml_scalar "$SYS_AGENT_ROOT/meta/GIT_DEFAULTS.yaml" "$1"
}

inventory_field() {
  local inventory_file="$1"
  local device_name="$2"
  local field="$3"
  python3 - "$inventory_file" "$device_name" "$field" <<'PY'
import sys
import yaml

inventory_file, device_name, field = sys.argv[1:]
with open(inventory_file, "r", encoding="utf-8") as fh:
    data = yaml.safe_load(fh) or {}

for device in data.get("devices", []):
    if str(device.get("name")) == device_name:
        value = device.get(field, "")
        if value is None:
            value = ""
        if isinstance(value, list):
            print(",".join(str(item) for item in value))
        else:
            print(str(value))
        break
PY
}

project_inventory_file() {
  printf '%s/inventory/devices.yaml\n' "$1"
}

project_device_field() {
  local project_root="$1"
  local device_name="$2"
  local field="$3"
  inventory_field "$(project_inventory_file "$project_root")" "$device_name" "$field"
}

platform_collect_manifest_file() {
  local platform="$1"
  local profile="${2:-}"
  local path="$SYS_AGENT_ROOT/platforms/$platform/collect-manifest.yaml"
  if [ -n "$profile" ] && [ -f "$SYS_AGENT_ROOT/platforms/$platform/profiles/$profile/collect-manifest.yaml" ]; then
    path="$SYS_AGENT_ROOT/platforms/$platform/profiles/$profile/collect-manifest.yaml"
  fi
  [ -f "$path" ] && printf '%s\n' "$path"
}

collect_manifest_entries() {
  local manifest="$1"
  python3 - "$manifest" <<'PY'
import base64
import sys

import yaml

manifest_path = sys.argv[1]
with open(manifest_path, "r", encoding="utf-8") as fh:
    data = yaml.safe_load(fh) or {}

for capture in data.get("captures", []):
    outfile = str(capture.get("outfile", "")).strip()
    command = capture.get("command", "")
    if isinstance(command, bool):
        command = "true" if command else "false"
    else:
        command = str(command)
    command = command.strip()
    if outfile and command:
        encoded = base64.b64encode(command.encode("utf-8")).decode("ascii")
        print(f"{outfile}\t{encoded}")
PY
}

run_transport_command() {
  local transport="$1"
  local host="$2"
  local user_name="$3"
  local port="$4"
  local bastion="$5"
  local command_timeout="$6"
  local cmd="$7"
  local -a wrapper=()

  if [ -n "$command_timeout" ] && command -v timeout >/dev/null 2>&1; then
    wrapper=(timeout "$command_timeout")
  fi

  case "$transport" in
    local)
      "${wrapper[@]}" bash -lc "$cmd"
      ;;
    ssh)
      local ssh_args=(-q -o BatchMode=yes -o StrictHostKeyChecking=accept-new -p "${port:-22}")
      [ -n "$bastion" ] && ssh_args+=(-J "$bastion")
      "${wrapper[@]}" ssh "${ssh_args[@]}" "${user_name}@${host}" "$cmd"
      ;;
    *)
      die "unsupported transport: $transport"
      ;;
  esac
}

capture_manifest_to_dir() {
  local manifest="$1"
  local dest_dir="$2"
  local collected_at="$3"
  local host_label="$4"
  local transport="$5"
  local host="$6"
  local user_name="$7"
  local port="$8"
  local bastion="$9"
  local command_timeout="${10}"

  [ -f "$manifest" ] || die "collect manifest not found: $manifest"
  mkdir -p "$dest_dir"

  while IFS=$'\t' read -r outfile command_b64; do
    [ -n "$outfile" ] || continue
    local command output_file command_text
    command_text="$(printf '%s' "$command_b64" | base64 --decode)"
    output_file="$dest_dir/$outfile"
    {
      echo "# collected_at_utc=$collected_at"
      echo "# host=$host_label"
      echo "# transport=$transport"
      echo "# command=$command_text"
      echo
      run_transport_command "$transport" "$host" "$user_name" "$port" "$bastion" "$command_timeout" "$command_text" || true
    } > "$output_file"
  done < <(collect_manifest_entries "$manifest")
}

platform_command_file() {
  local platform="$1"
  local kind="$2"
  local profile="${3:-}"
  local path="$SYS_AGENT_ROOT/platforms/$platform/$kind.txt"
  if [ -n "$profile" ] && [ -f "$SYS_AGENT_ROOT/platforms/$platform/profiles/$profile/$kind.txt" ]; then
    path="$SYS_AGENT_ROOT/platforms/$platform/profiles/$profile/$kind.txt"
  fi
  [ -f "$path" ] && printf '%s\n' "$path"
}

platform_default_command_file() {
  local platform="$1"
  local kind="$2"
  platform_command_file "$platform" "$kind"
}

platform_default_command() {
  local platform="$1"
  local kind="$2"
  local profile="${3:-}"
  local file
  file="$(platform_command_file "$platform" "$kind" "$profile" || true)"
  if [ -n "$file" ]; then
    sed '/^#/d;/^$/d' "$file" | paste -sd' ; ' -
  fi
}

schema_validate_path() {
  local schema_path="$1"
  local data_path="$2"
  python3 - "$schema_path" "$data_path" <<'PY'
import json
import sys
from pathlib import Path

import jsonschema
import yaml

schema_path, data_path = sys.argv[1:]
with open(schema_path, "r", encoding="utf-8") as fh:
    schema = yaml.safe_load(fh)

suffix = Path(data_path).suffix.lower()
with open(data_path, "r", encoding="utf-8") as fh:
    if suffix == ".json":
        data = json.load(fh)
    elif suffix in (".yaml", ".yml", ".md"):
        data = yaml.safe_load(fh)
    else:
        data = yaml.safe_load(fh)

jsonschema.validate(data, schema)
PY
}

jsonl_validate_path() {
  local schema_path="$1"
  local data_path="$2"
  python3 - "$schema_path" "$data_path" <<'PY'
import json
import sys

import jsonschema
import yaml

schema_path, data_path = sys.argv[1:]
with open(schema_path, "r", encoding="utf-8") as fh:
    schema = yaml.safe_load(fh)

with open(data_path, "r", encoding="utf-8") as fh:
    for index, line in enumerate(fh, start=1):
        stripped = line.strip()
        if not stripped:
            continue
        try:
            data = json.loads(stripped)
        except json.JSONDecodeError as exc:
            raise SystemExit(f"{data_path}: invalid JSON on line {index}: {exc}") from exc
        try:
            jsonschema.validate(data, schema)
        except jsonschema.ValidationError as exc:
            raise SystemExit(f"{data_path}: schema validation failed on line {index}: {exc.message}") from exc
PY
}

project_profile_file() {
  printf '%s/control/PROJECT_PROFILE.yaml\n' "$1"
}

project_instance() {
  yaml_scalar "$(project_profile_file "$1")" instance_id
}

project_platform() {
  yaml_scalar "$(project_profile_file "$1")" primary_platform
}

project_created_at() {
  yaml_scalar "$(project_profile_file "$1")" created_at_utc
}

default_mode() {
  yaml_scalar "$1/control/MODE_POLICY.yaml" default_mode
}

current_mode() {
  local file="$1/runtime/MODE_STATE.yaml"
  if [ -f "$file" ]; then
    yaml_scalar "$file" mode
  else
    default_mode "$1"
  fi
}

latest_raw_dir() {
  find "$1/raw-audit" -mindepth 1 -maxdepth 1 -type d -regextype posix-extended -regex '.*/[0-9]{8}T[0-9]{6}Z' 2>/dev/null | sort | tail -n 1
}

freshness_ttl_hours() {
  yaml_scalar "$1/control/FRESHNESS_POLICY.yaml" normalized_context_ttl_hours
}

freshness_status_from_last_refresh() {
  local last_refresh="$1"
  local ttl_hours="$2"
  python3 - "$last_refresh" "$ttl_hours" <<'PY'
from datetime import datetime, timezone
import sys

last_refresh = sys.argv[1].strip()
ttl_hours = int(sys.argv[2])
if not last_refresh:
    print("unknown")
    raise SystemExit(0)

if last_refresh.lower() == "unknown":
    print("unknown")
    raise SystemExit(0)

if len(last_refresh) == 16 and last_refresh.endswith("Z") and "T" in last_refresh and "-" not in last_refresh:
    last_refresh = datetime.strptime(last_refresh, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

now = datetime.now(timezone.utc)
try:
    last = datetime.strptime(last_refresh, "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
except ValueError:
    print("unknown")
    raise SystemExit(0)
delta_hours = (now - last).total_seconds() / 3600.0
print("fresh" if delta_hours <= ttl_hours else "stale")
PY
}

ensure_project_dirs() {
  local project_root="$1"
  mkdir -p \
    "$project_root/control" \
    "$project_root/context/normalized" \
    "$project_root/context/normalized/devices" \
    "$project_root/inventory" \
    "$project_root/research/notes" \
    "$project_root/runbooks" \
    "$project_root/raw-audit" \
    "$project_root/raw-audit/devices" \
    "$project_root/runtime" \
    "$project_root/runtime/devices" \
    "$project_root/logs" \
    "$project_root/state/backups" \
    "$project_root/state/checkpoints" \
    "$project_root/state/diffs" \
    "$project_root/state/exports" \
    "$project_root/state/imports" \
    "$project_root/state/rollback" \
    "$project_root/reports/history" \
    "$project_root/reports/latest" \
    "$project_root/.github/instructions" \
    "$project_root/.cursor/rules"
}

template_managed_paths() {
  cat <<'EOF'
.gitignore
LOCAL_CONTEXT.md
control/PROJECT_PROFILE.yaml
control/MODE_POLICY.yaml
control/PERMISSIONS_POLICY.yaml
control/FRESHNESS_POLICY.yaml
control/OPERATING_PROFILE.md
control/SYSTEM_MAP.md
control/TEMPLATE_MANAGED_PATHS.yaml
.github/instructions/project.instructions.md
.cursor/rules/00-project-scope.mdc
EOF
}

backup_path_if_exists() {
  local project_root="$1"
  local import_root="$2"
  local rel="$3"
  if [ -e "$project_root/$rel" ]; then
    mkdir -p "$(dirname "$import_root/$rel")"
    cp -R "$project_root/$rel" "$import_root/$rel"
  fi
}

move_path_to_import_if_exists() {
  local project_root="$1"
  local import_root="$2"
  local rel="$3"
  if [ -e "$project_root/$rel" ]; then
    mkdir -p "$(dirname "$import_root/$rel")"
    mv "$project_root/$rel" "$import_root/$rel"
  fi
}

merge_unique_lines() {
  local source_file="$1"
  local target_file="$2"
  local tmp_file
  tmp_file="$(mktemp)"
  cat "$target_file" > "$tmp_file"
  while IFS= read -r line || [ -n "$line" ]; do
    if ! grep -Fqx "$line" "$tmp_file"; then
      printf '%s\n' "$line" >> "$tmp_file"
    fi
  done < "$source_file"
  mv "$tmp_file" "$target_file"
}

write_local_context_file() {
  local project_root="$1"
  local instance_name="$2"
  local primary_platform="$3"
  local created_at_utc="$4"
  local version="$5"
  local preserve_existing="$6"
  local tmp_file existing_file

  tmp_file="$(mktemp)"
  render_template_file "$SYS_AGENT_ROOT/templates/instance/LOCAL_CONTEXT.md.tmpl" \
    "$tmp_file" "$instance_name" "$project_root" "$primary_platform" "$created_at_utc" "$version"
  existing_file="$project_root/LOCAL_CONTEXT.md"
  if [ "$preserve_existing" = "true" ] && [ -f "$existing_file" ]; then
    {
      echo
      echo "## Imported Legacy Context"
      echo
      cat "$existing_file"
    } >> "$tmp_file"
  fi
  mv "$tmp_file" "$existing_file"
}

write_local_context_preserving_project_notes() {
  local project_root="$1"
  local instance_name="$2"
  local primary_platform="$3"
  local created_at_utc="$4"
  local version="$5"
  local existing_file="$project_root/LOCAL_CONTEXT.md"
  local tmp_file preserved_file

  tmp_file="$(mktemp)"
  preserved_file="$(mktemp)"

  render_template_file "$SYS_AGENT_ROOT/templates/instance/LOCAL_CONTEXT.md.tmpl" \
    "$tmp_file" "$instance_name" "$project_root" "$primary_platform" "$created_at_utc" "$version"

  if [ -f "$existing_file" ]; then
    if grep -q '^## Imported Legacy Context$' "$existing_file"; then
      awk 'found { print } /^## Imported Legacy Context$/ { found=1; print }' "$existing_file" > "$preserved_file"
    elif grep -q '^## Project-Specific Context$' "$existing_file"; then
      awk 'found { print } /^## Project-Specific Context$/ { found=1; print }' "$existing_file" > "$preserved_file"
    else
      {
        echo "## Project-Specific Context"
        echo
        cat "$existing_file"
      } > "$preserved_file"
    fi

    if [ -s "$preserved_file" ]; then
      {
        echo
        cat "$preserved_file"
      } >> "$tmp_file"
    fi
  fi

  rm -f "$preserved_file"
  mv "$tmp_file" "$existing_file"
}

write_project_profile_file() {
  local project_root="$1"
  local instance_name="$2"
  local primary_platform="$3"
  local created_at_utc="$4"
  local version="$5"
  render_template_file "$SYS_AGENT_ROOT/templates/instance/control/PROJECT_PROFILE.yaml.tmpl" \
    "$project_root/control/PROJECT_PROFILE.yaml" "$instance_name" "$project_root" "$primary_platform" "$created_at_utc" "$version"
}

render_template_file() {
  local src="$1"
  local dest="$2"
  local instance_name="$3"
  local project_root="$4"
  local primary_platform="$5"
  local created_at_utc="$6"
  local version="$7"

  sed \
    -e "s#{{INSTANCE_NAME}}#${instance_name}#g" \
    -e "s#{{PROJECT_ROOT}}#${project_root}#g" \
    -e "s#{{PRIMARY_PLATFORM}}#${primary_platform}#g" \
    -e "s#{{CREATED_AT_UTC}}#${created_at_utc}#g" \
    -e "s#{{TEMPLATE_VERSION}}#${version}#g" \
    "$src" > "$dest"
}

copy_initial_templates() {
  local project_root="$1"
  local instance_name="$2"
  local primary_platform="$3"
  local created_at_utc="$4"
  local version="$5"
  local src rel dest

  while IFS= read -r -d '' src; do
    rel="${src#"$SYS_AGENT_ROOT/templates/instance/"}"
    dest="$project_root/$rel"
    mkdir -p "$(dirname "$dest")"
    if [[ "$src" == *.tmpl ]]; then
      dest="${dest%.tmpl}"
      if [ ! -f "$dest" ]; then
        render_template_file "$src" "$dest" "$instance_name" "$project_root" "$primary_platform" "$created_at_utc" "$version"
      fi
    elif [ ! -f "$dest" ]; then
      cp "$src" "$dest"
    fi
  done < <(find "$SYS_AGENT_ROOT/templates/instance" -type f -print0)
}

ensure_project_owned_defaults() {
  local project_root="$1"
  for project_owned in SECURITY_SCOPE.yaml CREDENTIAL_REFERENCES.yaml RESEARCH_POLICY.yaml; do
    if [ ! -f "$project_root/control/$project_owned" ]; then
      mkdir -p "$project_root/control"
      cp "$SYS_AGENT_ROOT/templates/instance/control/$project_owned" "$project_root/control/$project_owned"
    fi
  done
  if [ ! -f "$project_root/research/README.md" ]; then
    mkdir -p "$project_root/research"
    cp "$SYS_AGENT_ROOT/templates/instance/research/README.md" "$project_root/research/README.md"
  fi
}

write_mode_state_from_policy() {
  local project_root="$1"
  local mode_file="$project_root/runtime/MODE_STATE.yaml"
  local policy="$project_root/control/MODE_POLICY.yaml"
  local mode="${2:-}"

  [ -n "$mode" ] || mode="$(yaml_scalar "$policy" default_mode)"
  cat > "$mode_file" <<EOF
schema_version: 1
mode: $mode
requires_confirmation_for_critical: $(yaml_bool "$policy" requires_confirmation_for_critical)
auto_log_actions: $(yaml_bool "$policy" auto_log_actions)
auto_snapshot_touched_files: $(yaml_bool "$policy" auto_snapshot_touched_files)
allow_package_changes: $(yaml_bool "$policy" allow_package_changes)
allow_service_changes: $(yaml_bool "$policy" allow_service_changes)
allow_network_changes: $(yaml_bool "$policy" allow_network_changes)
allow_boot_changes: $(yaml_bool "$policy" allow_boot_changes)
EOF
}

write_runtime_state() {
  local project_root="$1"
  local last_refresh="$2"
  local latest_raw="$3"
  local normalization_manifest="$4"
  local freshness_status="$5"
  local runtime_file="$project_root/runtime/RUNTIME_STATE.yaml"
  local instance_id platform mode version

  instance_id="$(project_instance "$project_root")"
  platform="$(project_platform "$project_root")"
  mode="$(current_mode "$project_root")"
  version="$(template_version)"
  [ -n "$last_refresh" ] || last_refresh="unknown"
  [ -n "$latest_raw" ] || latest_raw="unknown"
  [ -n "$normalization_manifest" ] || normalization_manifest="unknown"
  [ -n "$freshness_status" ] || freshness_status="unknown"
  cat > "$runtime_file" <<EOF
schema_version: 1
instance_id: $instance_id
project_root: $project_root
template_version: $version
mode: $mode
project_platform: $platform
last_refresh_utc: "$last_refresh"
latest_raw_audit_dir: "$latest_raw"
normalization_manifest: "$normalization_manifest"
freshness_status: "$freshness_status"
normalized_context_dir: $project_root/context/normalized
EOF
}

write_device_state() {
  local project_root="$1"
  local device_name="$2"
  local platform="$3"
  local collected_at="$4"
  local collection_scope="$5"
  local state_dir="$project_root/runtime/devices/$device_name"
  mkdir -p "$state_dir"
  cat > "$state_dir/DEVICE_STATE.yaml" <<EOF
schema_version: 1
device_name: $device_name
platform_family: $platform
collection_scope: $collection_scope
last_collected_at_utc: "$collected_at"
EOF
}

legacy_runtime_last_refresh() {
  local project_root="$1"
  local value=""

  if [ -f "$project_root/runtime/RUNTIME_STATE.yaml" ]; then
    value="$(yaml_scalar "$project_root/runtime/RUNTIME_STATE.yaml" last_refresh_utc || true)"
  fi

  if [ -z "$value" ] && [ -f "$project_root/runtime/LAST_REFRESH.md" ]; then
    value="$(sed -n 's/^Last refresh:[[:space:]]*//p' "$project_root/runtime/LAST_REFRESH.md" | head -n 1)"
  fi

  if [ -z "$value" ] && [ -f "$project_root/runtime/SYSTEM_STATE.yaml" ]; then
    value="$(yaml_scalar "$project_root/runtime/SYSTEM_STATE.yaml" collected_at_utc || true)"
  fi

  if [ -n "$value" ]; then
    python3 - "$value" <<'PY'
from datetime import datetime, timezone
import sys

value = sys.argv[1].strip().strip('"')
if not value:
    print("")
    raise SystemExit(0)

if len(value) == 16 and value.endswith("Z") and "T" in value and "-" not in value:
    dt = datetime.strptime(value, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc)
    print(dt.strftime("%Y-%m-%dT%H:%M:%SZ"))
else:
    print(value)
PY
  fi
}

upgrade_runtime_contracts() {
  local project_root="$1"
  local mode policy_default last_refresh ttl freshness latest_raw normalization_manifest

  policy_default="$(yaml_scalar "$project_root/control/MODE_POLICY.yaml" default_mode)"
  mode="$policy_default"
  if [ -f "$project_root/runtime/MODE_STATE.yaml" ]; then
    mode="$(yaml_scalar "$project_root/runtime/MODE_STATE.yaml" mode || true)"
  fi
  [ -n "$mode" ] || mode="$policy_default"
  write_mode_state_from_policy "$project_root" "$mode"

  last_refresh="$(legacy_runtime_last_refresh "$project_root")"
  latest_raw="$(latest_raw_dir "$project_root")"
  [ -n "$latest_raw" ] || latest_raw="$(yaml_scalar "$project_root/runtime/SYSTEM_STATE.yaml" latest_raw_audit_dir 2>/dev/null || true)"
  normalization_manifest="$project_root/context/normalized/NORMALIZATION_MANIFEST.yaml"
  [ -f "$normalization_manifest" ] || normalization_manifest=""
  ttl="$(freshness_ttl_hours "$project_root")"
  freshness="$(freshness_status_from_last_refresh "$last_refresh" "$ttl")"
  write_runtime_state "$project_root" "$last_refresh" "$latest_raw" "$normalization_manifest" "$freshness"
}

refresh_project_profile_version() {
  local project_root="$1"
  local instance_id platform created_at version
  instance_id="$(project_instance "$project_root")"
  platform="$(project_platform "$project_root")"
  created_at="$(project_created_at "$project_root")"
  version="$(template_version)"
  write_project_profile_file "$project_root" "$instance_id" "$platform" "$created_at" "$version"
}

is_critical_action() {
  local project_root="$1"
  local action_class="$2"
  awk -v action="$action_class" '
    /^critical_action_classes:/ { in_block=1; next }
    in_block && /^[^[:space:]-]/ { in_block=0 }
    in_block && $1 == "-" && $2 == action { found=1; exit }
    END { exit(found ? 0 : 1) }
  ' "$project_root/control/PERMISSIONS_POLICY.yaml"
}

project_root_from_optional_arg() {
  [ $# -ge 1 ] || die "missing project or instance name"
  resolve_project_arg "$1"
}

render_project_template_subset() {
  local project_root="$1"
  local instance_name="$2"
  local primary_platform="$3"
  local created_at_utc="$4"
  local version="$5"
  local preserve_existing_context="${6:-false}"

  if [ "$preserve_existing_context" = "true" ]; then
    write_local_context_preserving_project_notes "$project_root" "$instance_name" "$primary_platform" "$created_at_utc" "$version"
  else
    write_local_context_file "$project_root" "$instance_name" "$primary_platform" "$created_at_utc" "$version" "false"
  fi
  write_project_profile_file "$project_root" "$instance_name" "$primary_platform" "$created_at_utc" "$version"
  render_template_file "$SYS_AGENT_ROOT/templates/instance/control/SYSTEM_MAP.md.tmpl" \
    "$project_root/control/SYSTEM_MAP.md" "$instance_name" "$project_root" "$primary_platform" "$created_at_utc" "$version"
  cp "$SYS_AGENT_ROOT/templates/instance/control/MODE_POLICY.yaml" "$project_root/control/MODE_POLICY.yaml"
  cp "$SYS_AGENT_ROOT/templates/instance/control/PERMISSIONS_POLICY.yaml" "$project_root/control/PERMISSIONS_POLICY.yaml"
  cp "$SYS_AGENT_ROOT/templates/instance/control/FRESHNESS_POLICY.yaml" "$project_root/control/FRESHNESS_POLICY.yaml"
  cp "$SYS_AGENT_ROOT/templates/instance/control/OPERATING_PROFILE.md" "$project_root/control/OPERATING_PROFILE.md"
  cp "$SYS_AGENT_ROOT/templates/instance/control/TEMPLATE_MANAGED_PATHS.yaml" "$project_root/control/TEMPLATE_MANAGED_PATHS.yaml"
  ensure_project_owned_defaults "$project_root"
  mkdir -p "$project_root/.github/instructions" "$project_root/.cursor/rules"
  cp "$SYS_AGENT_ROOT/templates/instance/.github/instructions/project.instructions.md" \
    "$project_root/.github/instructions/project.instructions.md"
  cp "$SYS_AGENT_ROOT/templates/instance/.cursor/rules/00-project-scope.mdc" \
    "$project_root/.cursor/rules/00-project-scope.mdc"
  if [ -f "$project_root/.gitignore" ]; then
    merge_unique_lines "$SYS_AGENT_ROOT/templates/instance/.gitignore" "$project_root/.gitignore"
  else
    cp "$SYS_AGENT_ROOT/templates/instance/.gitignore" "$project_root/.gitignore"
  fi
}

write_adoption_report() {
  local project_root="$1"
  local import_root="$2"
  local report="$project_root/reports/latest/ADOPTION_REPORT.md"
  cat > "$report" <<EOF
# Adoption Report

- generated_at_utc: $(timestamp_utc)
- import_root: $import_root

## Notes

- Template-managed conflicts were backed up before replacement.
- Legacy control-plane instruction surfaces were moved into the import archive when present.
- Project-specific data outside managed paths was preserved in place.
- Legacy runtime logs that failed current SACST JSONL schemas were archived and replaced with fresh managed log files.
EOF
}

migrate_legacy_logs_if_needed() {
  local project_root="$1"
  local import_root="$2"
  local log_file schema_name archive_path

  for pair in \
    "logs/actions.jsonl:action-log.schema.yaml" \
    "logs/critical-actions.jsonl:action-log.schema.yaml" \
    "logs/feedback.jsonl:feedback.schema.yaml" \
    "logs/sessions.jsonl:session-log.schema.yaml"; do
    log_file="${pair%%:*}"
    schema_name="${pair##*:}"
    if [ -s "$project_root/$log_file" ] && ! jsonl_validate_path "$SYS_AGENT_ROOT/schemas/$schema_name" "$project_root/$log_file" >/dev/null 2>&1; then
      archive_path="$import_root/legacy-logs/$log_file"
      mkdir -p "$(dirname "$archive_path")"
      mv "$project_root/$log_file" "$archive_path"
      : > "$project_root/$log_file"
    fi
  done
}
