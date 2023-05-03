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
    dotnet new console --output presentation.Console
    mkdir src/$nameProject
    dotnet new classlib --output src/$nameProject/$nameProject".Application"
    dotnet new classlib --output src/$nameProject/$nameProject".Domain"
    dotnet new classlib --output src/$nameProject/$nameProject".Infraestructure"

    dotnet sln add presentation.Console
    dotnet sln add src/$nameProject/$nameProject".Application"
    dotnet sln add src/$nameProject/$nameProject".Domain"
    dotnet sln add src/$nameProject/$nameProject".Infraestructure"

    dotnet add presentation.Console reference src/$nameProject/$nameProject".Application"
    dotnet add presentation.Console reference src/$nameProject/$nameProject".Infraestructure"
    dotnet add src/$nameProject/$nameProject".Application" reference src/$nameProject/$nameProject".Domain"
    dotnet add src/$nameProject/$nameProject".Infraestructure" reference src/$nameProject/$nameProject".Domain"

    Start-Process $nameProject".sln"
}