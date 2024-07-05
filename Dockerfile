FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

ARG SECRET_TOKEN

WORKDIR /app

RUN echo "Testing github secrets with token: ${SECRET_TOKEN}"

# Copy everything
COPY Dotnet.Hello/Dotnet.Hello ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /dockerimagetest/out .
#ENTRYPOINT ["Dotnet.Hello.dll"]
ENTRYPOINT ["dotnet", "Dotnet.Hello.dll"]
