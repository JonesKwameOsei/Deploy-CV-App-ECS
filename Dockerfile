#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["myWebCVApp/myWebCVApp.csproj", "myWebCVApp/"]
RUN dotnet restore "./myWebCVApp/myWebCVApp.csproj"
COPY . .
WORKDIR "/src/myWebCVApp"
RUN dotnet build "./myWebCVApp.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publsih and build app
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./myWebCVApp.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myWebCVApp.dll"]