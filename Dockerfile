# Usa una imagen base de Java 17 estable (puedes cambiar a 21 si lo deseas)
FROM eclipse-temurin:17-jdk-alpine

ARG VERSION
# Establece el directorio de trabajo
WORKDIR /app

# Copia el JAR del proyecto al contenedor (ajusta el nombre según tu proyecto)
COPY target/my-app-${VERSION}.jar app.jar

# Expone el puerto (ajústalo según tu aplicación)
EXPOSE 8080

# Comando por defecto
ENTRYPOINT ["java", "-jar", "app.jar"]