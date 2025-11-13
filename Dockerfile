# --- Стадия сборки (build) ---
# Используем полный .NET SDK для сборки проекта
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Копируем файлы проекта и восстанавливаем зависимости
COPY AspNetCoreApp/AspNetCoreApp.csproj .
RUN dotnet restore

# Копируем все остальные исходные файлы и публикуем приложение
COPY AspNetCoreApp/ .
RUN dotnet publish -c Release -o /app/publish

# --- Стадия выполнения (runtime) ---
# Используем Alpha-образ для уменьшения размера
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine
WORKDIR /app

# Копируем только опубликованные файлы из стадии 'build'
COPY --from=build /app/publish .

# Указываем порт и команду для запуска приложения
EXPOSE 8080
# ВАЖНО: Замените <YOUR_PROJECT_NAME> на имя DLL вашего проекта!
CMD ["dotnet", "AspNetCoreApp.dll"]



