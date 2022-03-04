FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["MolnBaserade/MolnBaserade.csproj", "./"]
RUN dotnet restore "MolnBaserade.csproj"
COPY . .
WORKDIR "/src/MolnBaserade"
RUN dotnet build "MolnBaserade.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MolnBaserade.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MolnBaserade.dll"]