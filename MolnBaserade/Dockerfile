# Baserar kommande steg p� image-milj�n Asp.net  och s�tter den k�llan �ven som variabeln base f�r framtida use.
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

#G�r in i �/app�-mappen i sitt arbete att skapa din Docker-image (som sedan anv�nds f�r din container)
WORKDIR /app

#�ppnar upp en port i containern s� att den g�r att n� utifr�n containern
EXPOSE 8080

# Baserar kommande steg p� image-milj�n .net  och s�tter den k�llan �ven som variabeln build f�r framtida use.
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

#G�r in i �/app�-mappen i sitt arbete att skapa din Docker-image (som sedan anv�nds f�r din container)
WORKDIR /app

#kopierar din cs-projektfil (med namnet p� ditt projekt) till sin root folder ( �./� ) i den blivande Docker-imagen
COPY MolnBaserade.csproj ./

# K�r dotnet-kommandot �restore�
RUN dotnet restore

#kopierar inenh�lllet i din root-mapp till sin egen blivande root-mapp i Docker-milj�n
COPY . ./

#G�r in i mappen �/app� f�r sina n�stkommande steg i Docker-milj�n
WORKDIR /app
RUN dotnet build -c Release -o /app/build

# Anv�nder den tidigare milj�n �build� som vi satte upp ovan fr�n �dotnet sdk� och s�tter den som variabeln publish

FROM build AS publish

# K�r dotnet-kommandot �publish� och markerar den som �Release� samt h�nvisar den till mappen �/app/publish� i Docker-milj�n
RUN dotnet publish -c Release -o /app/publish


# Anv�nder den tidigare milj�n �base� som vi satte upp ovan fr�n �asp dotnet� och s�tter den som variabeln final

FROM base AS final


#G�r in i mappen �/app� f�r sina n�stkommande steg i Docker-milj�n och kopierar in inneh�llet 

WORKDIR /app
COPY --from=publish /app/publish .

# Ber�ttar f�r den framtida Docker-containern vilken startfil/startv�g den ska initiera och k�ra f�rst vid container-starten n�r v�l Docker eller Kubernetes kallar p� den
ENTRYPOINT ["dotnet", "MolnBaserade.dll"]