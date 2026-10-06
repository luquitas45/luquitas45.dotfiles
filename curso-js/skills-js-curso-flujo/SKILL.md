---
name: js-curso-flujo
description: "Trigger: /curso-js, curso javascript, hice el ejercicio, termine el video, termine el proyecto. Flujo de trabajo para aprender JavaScript con Jon Mircha usando Obsidian."
license: Apache-2.0
metadata:
  author: el-gentleman
  version: "1.0"
---

## Activation Contract

Use this skill when the user is working through the Jon Mircha JavaScript course and reports progress.

Triggers:
- `/curso-js` or mentioning the JavaScript course
- "hice el ejercicio", "terminé el video", "completé el proyecto"
- Any reference to the js-curso-jonmircha workspace or Obsidian vault

## Hard Rules

- The vault lives at `/home/lucas/alejandria/js-curso-jonmircha/`
- After each completed task, run the post-task questionnaire before updating Obsidian
- Never write the user's answers for them; ask and wait for responses
- Update only the specific note that corresponds to the completed video/exercise
- Keep the canvas-curso progress tracker updated

## Decision Gates

| Situation | Action |
| --- | --- |
| User says "terminé el video X" | Run questionnaire for that video note |
| User says "hice el ejercicio" | Run questionnaire for the exercise note |
| User says "terminé el proyecto" | Run questionnaire for the project note |
| User asks "qué sigue?" | Show next uncompleted item from the current block |
| User wants to skip | Ask why, mark as skipped in the note |

## Post-Task Questionnaire

Always ask these 3-5 questions after a completed task:

1. **¿Qué aprendiste o reforzaste con este ejercicio/video?**
2. **¿Qué te costó o qué error tuviste?**
3. **¿Qué snippet de código te servirá en el futuro?** (optional)
4. **¿Qué calificación le darías a tu comprensión del tema?** (1-5)
5. **¿Algo más que quieras anotar?**

After collecting answers, update the corresponding Obsidian note with:
- Status: ✅ Completado
- Aprendizaje: user's answer to Q1
- Dificultades: user's answer to Q2
- Snippet útil: user's answer to Q3 (if provided)
- Fecha de completado: today's date

## Execution Steps

1. Identify which video/exercise/project the user completed
2. Read the corresponding note from the vault
3. Run the questionnaire (ask one question at a time or all at once)
4. Collect answers
5. Update the note with the collected information
6. Mark as completed
7. Suggest the next step

## Output Contract

Return:
- Which note was updated
- The answers collected
- The next recommended video/exercise/project
- Any blockers or suggestions

## References

- Vault path: `/home/lucas/alejandria/js-curso-jonmircha/`
- Course playlist: https://www.youtube.com/playlist?list=PLvq-jIkSeTUZ6QgYYO3MwG9EMqC-KoLXA
