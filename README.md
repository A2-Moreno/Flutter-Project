# Descripción
Esta solución móvil facilita el proceso de evaluación por pares en el entorno académicos. Permite a profesores y estudiantes interactuar en un mismo sistema, gestionar cursos, grupos y evaluaciones de forma estructurada.

El sistema implementa un modelo de coevaluación en el que los estudiantes califican el desempeño de sus compañeros de grupo, mientras que el profesor obtiene métricas para analizar tanto el rendimiento individual como grupal.

La aplicación identifica automáticamente el rol del usuario al iniciar sesión y adapta la interfaz y funcionalidades disponibles según el perfil.

# Propósito
El propósito principal de la aplicación es mejorar la objetividad en la evaluación de trabajos grupales, resolviendo una problemática común: la dificultad de identificar el aporte real de cada integrante.

A través de la evaluación por pares, el sistema permite:

* Generar métricas del desempeño individual.
* Apoyar al profesor en la toma de decisiones al momento de calificar.
* Reducir sesgos en las evaluaciones.

# Funcionalidades Principales

### Profesor

* Creación y gestión de cursos.
* Registro de grupos de estudiantes (mediante carga de archivos CSV).
* Creación de evaluaciones con criterios definidos.
* Visualización de resultados individuales y grupales.
* Análisis de desempeño a través de promedios y métricas.

### Estudiante

* Acceso a cursos asignados.
* Visualización de grupos de trabajo.
* Evaluación de compañeros mediante criterios establecidos.
* Consulta de resultados personales por actividad.

### Sistema

* Autenticación con detección de rol.
* Procesamiento de archivos CSV para carga masiva de estudiantes.
* Generación de promedios y métricas de evaluación.
* Navegación diferenciada según tipo de usuario.
* Interfaz intuitiva basada en prototipo diseñado en Figma.

# Alcance del proyecto

El alcance de este proyecto contempla el desarrollo de una aplicación móvil funcional para la evaluación por pares, incluyendo:

* Gestión de usuarios.
* Creación y administración de cursos.
* Registro de grupos de estudiantes.
* Implementación del proceso de evaluación por pares.
* Visualización de resultados y métricas.

El sistema está diseñado como un prototipo funcional, con la limitación de no poseer una conexión directa al sistema académico.

# Justificación

Cada vez que se trabaja en grupo casi siempre aparece el mismo problema, los profesores no pueden saber con total certeza quién trabajó y quién no. En la entrevista realizada con la profesora Katherine, ella nos contó que cuando deja trabajos en grupos, además de la entrega, suele complementar con sustentaciones para asegurarse de que todos hayan participado y entiendan lo que hicieron. También nos mencionó que nunca ha usado una herramienta de este tipo, y que las coevaluaciones pueden fallar por el tema de la amistad, porque a veces se califican bien “para no quedar mal” con el compañero.
En cuanto a las soluciones similares que encontramos, aunque algunas se parecen a lo que buscamos, ninguna cumple completamente con lo que requiere este proyecto. Por ejemplo, varias no permiten que los estudiantes vean sus resultados por actividad, o no le ofrecen al profesor un promedio del desempeño del grupo a lo largo de varias entregas, entre otras funciones.
Por eso se plantea esta solución, un aplicativo móvil intuitivo, pensado para facilitar la coevaluación de los trabajos en grupos y generar datos claros que permitan analizar el desempeño real de cada integrante y del grupo en general. De esta forma, el profesor puede tomar decisiones conscientes a la hora de calificar.
Debido a esta problemática han surgido múltiples soluciones que integran el modelo de evaluación de pares para determinar el desempeño de cada estudiante de manera más efectiva, como Peerceptiv, FeedbackFruits y CATME, de las cuales se adquieren características relevantes para los requerimientos y se integran en la propuesta, como la evaluación anónima, rubrica detallada y analíticas.

# Enlaces a Youtube

* Demo de gestión académica: https://youtu.be/IX-7nI-AgBM
* Demo de evaluación y reportes: https://youtu.be/KKu63El29o8
* Pruebas de widget: https://youtu.be/1W3xTW6TOK4
* Pruebas de integración:
* Implementación de caché: https://youtu.be/SyaLEo9Ncjg
* Revisión del código: https://youtu.be/rB1FUkyyJV8