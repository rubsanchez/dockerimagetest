FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /dockerimagetest

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /dockerimagetest
COPY --from=build-env /dockerimagetest/out .
#ENTRYPOINT ["Dotnet.Hello.dll"]
ENTRYPOINT ["dotnet", "Dotnet.Hello.dll"]