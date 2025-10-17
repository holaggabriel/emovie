# emovie
eMovie es una aplicación móvil desarrollada con Flutter, diseñada para explorar, descubrir y visualizar información sobre películas.

## 🧱 Tecnologías y dependencias principales

* **Flutter** 🐦
* **Riverpod** – para la gestión del estado
* **Hive** – para almacenamiento local y manejo de cache offline
* **API utilizada** – [The Movie Database (TMDb)](https://developers.themoviedb.org)

---

## ⚙️ Configuración inicial

Al clonar o descargar el proyecto, es necesario crear un archivo llamado **`.env`** en la raíz del proyecto.

Dentro de ese archivo se deben definir las siguientes variables de entorno (usa tus propios valores o los proporcionados por el equipo):

```env
API_TOKEN=tu_token_aqui
API_BASE_URL=tu_url_api_aqui
IMAGE_BASE_URL=tu_url_imagenes_aqui
```

---

## 🚀 Ejecución del proyecto

1. Instalar dependencias:

   ```bash
   flutter pub get
   ```

2. Crear el archivo `.env` con las variables mencionadas anteriormente.

3. Ejecutar el proyecto:

   ```bash
   flutter run
   ```

---

## 🎥 Demostración
https://github.com/user-attachments/assets/1748be60-a9b9-4ea8-8ff8-7fe9632b9156
