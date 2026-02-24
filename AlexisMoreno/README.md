# Referentes

### 1. Peerceptiv

Peerceptiv es una Plataforma profesional basada en peer reviews que incentiva una participación activa en los estudiantes y ofrece analíticas para medir la calidad del trabajo y retroalimentación realizados. Esta plataforma brinda una herramienta completamente personalizable que permite evaluar las contribuciones de los miembros del equipo de trabajo de manera anónima, adquiriendo información sobre las dinámicas de cada grupo.

### 2. FeedbackFruits

FeedbackFruits es una solución enfocada en solventar el gran gasto de tiempo y poca fiabilidad en el manejo de peer reviews automatizando la retroalimentación mutua y brindando apoyo por medio de rubricas estructuradas y asistencia de IA.

### 3. CATME

CATME es una herramienta de Purdue University para la evaluación de la efectividad de los miembros de un equipo, midiendo dimensiones clave como contribución al trabajo, interacción con compañeros, calidad esperada, etc. Permite que cada miembro del grupo evalúe a los demás y a sí mismo en una escala numérica e incluye opciones de análisis y reportes para docentes.

# Composición y Diseño

Se propone una sola aplicación para ambos roles, profesores y estudiantes, que esté personalizada para incluir las funciones requeridas por el usuario según su rol. Se toma esta decisión puesto que permite la amplia reutilización de componentes, una característica valiosa dado que habrá funciones y datos a los que tanto profesores como estudiantes pueden acceder. Esto ofrece una experiencia más consistente, reduce el esfuerzo necesario para el mantenimiento y mejora la escalabilidad.

# Descripción del Flujo

![Diagrama del flujo](./MovilFlowchart.jpg)

# Justificación

Al momento de evaluar trabajos colaborativos se suele encontrar una dificultad para hacerlo de una manera justa, pues no es raro que uno de los integrantes del equipo no contribuya tanto como el resto. La profesora Katherine Ospino afirma que debe tomar medidas adicionales como solicitar sustentaciones, “siempre es difícil, a veces los estudiantes engañan”. Asimismo, manifiesta que preguntar por el rendimiento de los miembros del equipo directamente no es muy útil, “por amistad evitan dejar mal a su compañero”.
Debido a esta problemática han surgido múltiples soluciones que integran el modelo de evaluación de pares para determinar el desempeño de cada estudiante de manera más efectiva, como Peerceptiv, FeedbackFruits y CATME, de las cuales se adquieren características relevantes para los requerimientos y se integran en la propuesta, como la evaluación anónima, rubrica detallada y analíticas.

# Prototipo

Enlace al [prototipo Figma](https://www.figma.com/proto/tuSkHcAfMcPV2gmbJxGlqd/M%C3%B3vil?page-id=0%3A1&node-id=1-3216&p=f&viewport=532%2C230%2C0.51&t=9v9rngFO943F0bTn-1&scaling=scale-down&content-scaling=fixed&starting-point-node-id=1%3A3216&show-proto-sidebar=1)

| Login                        | Dashboard                                      | Clase                                |
| ---------------------------- | ---------------------------------------------- | ------------------------------------ |
| ![Pantalla Login](Login.png) | ![Pantalla Dashboard](DashboardEstudiante.png) | ![Pantalla Clase](ClaseProfesor.png) |

| Grupos                                 | Integrantes                                                    |
| -------------------------------------- | -------------------------------------------------------------- |
| ![Pantalla Grupos](GruposProfesor.png) | ![Pantalla Integrantes de grupo](IntegrantesGrupoProfesor.png) |
