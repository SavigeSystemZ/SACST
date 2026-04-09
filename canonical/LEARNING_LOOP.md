# Sys-Agent Core - Learning Loop

## Purpose
Enable supervised self-evolution of the framework without risking autonomous corruption.

## Workflow
1. **Feedback Capture:** Session outcomes and user ratings (liked/disliked) are recorded in `logs/feedback.jsonl`.
2. **Candidate Generation:** The agent extracts repeated successful patterns into `framework/learning/candidates/`.
3. **Promotion Gate:** The user explicitly reviews candidates.
4. **Acceptance/Rejection:**
   - Accepted patterns are moved to `framework/learning/accepted/` and integrated into `framework/templates/`.
   - Rejected patterns are moved to `framework/learning/rejected/`.