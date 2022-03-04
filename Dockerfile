# Baserar kommande steg på image-miljön Asp.net  och sätter den källan även som variabeln base för framtida use.
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

#Går in i “/app”-mappen i sitt arbete att skapa din Docker-image (som sedan används för din container)
WORKDIR /app

#Öppnar upp en port i containern så att den går att nå utifrån containern
EXPOSE 8080

# Baserar kommande steg på image-miljön .net  och sätter den källan även som variabeln build för framtida use.
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

#Går in i “/app”-mappen i sitt arbete att skapa din Docker-image (som sedan används för din container)
WORKDIR /app

#kopierar din cs-projektfil (med namnet på ditt projekt) till sin root folder ( “./” ) i den blivande Docker-imagen
COPY MolnBaserade.csproj ./

# Kör dotnet-kommandot “restore”
RUN dotnet restore

#kopierar inenhålllet i din root-mapp till sin egen blivande root-mapp i Docker-miljön
COPY . ./

#Går in i mappen “/app” för sina nästkommande steg i Docker-miljön
WORKDIR /app
RUN dotnet build -c Release -o /app/build

# Använder den tidigare miljön “build” som vi satte upp ovan från “dotnet sdk” och sätter den som variabeln publish

FROM build AS publish

# Kör dotnet-kommandot “publish” och markerar den som “Release” samt hänvisar den till mappen “/app/publish” i Docker-miljön
RUN dotnet publish -c Release -o /app/publish


# Använder den tidigare miljön “base” som vi satte upp ovan från “asp dotnet” och sätter den som variabeln final

FROM base AS final


#Går in i mappen “/app” för sina nästkommande steg i Docker-miljön och kopierar in innehållet 

WORKDIR /app
COPY --from=publish /app/publish .

# Berättar för den framtida Docker-containern vilken startfil/startväg den ska initiera och köra först vid container-starten när väl Docker eller Kubernetes kallar på den
ENTRYPOINT ["dotnet", "MolnBaserade.dll"]