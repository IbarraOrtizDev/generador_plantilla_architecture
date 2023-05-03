Write-Host $args
$nameProject = $args[1]
function VerificaNameProject(){
    $verifica = 1
    while($verifica -eq 1){
        $nameProject = Read-Host "Por favor escribe el nombre del proyecto"
        if($nameProject.Length -gt 0){
            $verifica = 2
        }
    }
    return $nameProject
}

if ($args.Length -gt 0 -And $args[0] -eq "New") {
    if (-Not($args[1].Length -gt 0)) {
        $nameProject = VerificaNameProject
    }
    Write-Host "Generando el proyecto"
    mkdir $nameProject
    Set-Location $nameProject
    dotnet new sln
    mkdir src/$nameProject

    dotnet new webapi --output presentation.Api
    dotnet add presentation.Api package MediatR

    dotnet new classlib --output src/$nameProject/$nameProject".Application"
    dotnet add src/$nameProject/$nameProject".Application" package MediatR
    dotnet add src/$nameProject/$nameProject".Application" package MediatR.Extensions.Microsoft.DependencyInjection
    dotnet add src/$nameProject/$nameProject".Application" package AutoMapper

    dotnet new classlib --output src/$nameProject/$nameProject".Domain"

    dotnet new class -n DtoInit -o src/$nameProject/$nameProject".Domain"/DTOs
    dotnet new class -n EntityInit -o src/$nameProject/$nameProject".Domain"/Entities
    dotnet new class -n EnumInit -o src/$nameProject/$nameProject".Domain"/Enums
    dotnet new class -n ExceptionInit -o src/$nameProject/$nameProject".Domain"/Exceptions
    dotnet new class -n HelperInit -o src/$nameProject/$nameProject".Domain"/Helpers
    dotnet new class -n PortInit -o src/$nameProject/$nameProject".Domain"/Ports
    dotnet new class -n ServiceInit -o src/$nameProject/$nameProject".Domain"/Services


    #Infraestructure
    dotnet new classlib --output src/$nameProject/$nameProject".Infraestructure"

    dotnet new class -n AdapterInit -o src/$nameProject/$nameProject".Infraestructure"/Adapters
    dotnet new class -n ConfigurationInit -o src/$nameProject/$nameProject".Infraestructure"/Configurations
    dotnet new class -n Context -o src/$nameProject/$nameProject".Infraestructure"/Context
    dotnet new class -n HelperInit -o src/$nameProject/$nameProject".Infraestructure"/Helpers
    dotnet new class -n JsonSeeds -o src/$nameProject/$nameProject".Infraestructure"/JsonSeeds
    dotnet new class -n AutoMapperProfile -o src/$nameProject/$nameProject".Infraestructure"/Mappings

    dotnet add src/$nameProject/$nameProject".Infraestructure" package AutoMapper
    dotnet add src/$nameProject/$nameProject".Infraestructure" package AutoMapper.Extensions.Microsoft.DependencyInjection
    dotnet add src/$nameProject/$nameProject".Infraestructure" package Microsoft.EntityFrameworkCore
    dotnet add src/$nameProject/$nameProject".Infraestructure" package Microsoft.EntityFrameworkCore.SqlServer


    dotnet sln add presentation.Api
    dotnet sln add src/$nameProject/$nameProject".Application"
    dotnet sln add src/$nameProject/$nameProject".Domain"
    dotnet sln add src/$nameProject/$nameProject".Infraestructure"

    dotnet add presentation.Api reference src/$nameProject/$nameProject".Application"
    dotnet add presentation.Api reference src/$nameProject/$nameProject".Infraestructure"
    dotnet add src/$nameProject/$nameProject".Application" reference src/$nameProject/$nameProject".Domain"
    dotnet add src/$nameProject/$nameProject".Infraestructure" reference src/$nameProject/$nameProject".Domain"

    Start-Process $nameProject".sln"
}