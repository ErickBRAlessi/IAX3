Unit Resources;
INTERFACE
//declara o type que seram usados ao longo do programa
type position = record //value determina o terreno (1 = terra, 2 = agua), ocupation se tem algum player lá
  value: integer;
  ocupation: boolean;
end;
type mapType = array[0..15,0..15] of position; //mapa é composto por 256 posições possíveis
type playerStatus = record //cada player carregara sua comida, água e posição
  be: boolean;
  comida: integer;
  agua: integer;
  lifeTimeCycles: integer;
  xpos: integer;
  ypos: integer;
end;
type playerType = array[0..255] of playerStatus; //todos os player possíveis no ambiente
//
function mapGen(): mapType;
procedure mapRefresh(map : mapType; player : playerType);
function playerMove(playerAux:playerType;map:mapType) : playerType;
function playerStatusRefresh(playerAux:playerType; map:mapType):playerType;
function playerDead(playerAux:playerStatus):playerStatus;

IMPLEMENTATION
//método de ordenação genérico, tem como entrada um array com os elementos e a quantidade de elementos na forma de integer
function mapGen(): mapType;
var xpos, ypos: integer;  map : mapType;
begin
  randomize();
  for ypos:= 0 to 15 do
  begin
    for xpos:= 0 to 15 do
    begin
      while (map[xpos,ypos].value = 0) do
      begin
        map[xpos,ypos].value:=random(3);
      end;
    end;
  end;
  mapGen:=map;
end;


procedure mapRefresh(map : mapType; player : playerType);
var ypos, xpos, count : integer;
begin
  //testar
  for count:=0 to 255 do
  begin
    if (player[count].be = true) then
    map[player[count].xpos,player[count].ypos].ocupation:= true;
  end;
  for ypos:= 0 to 15 do
  begin
    for xpos:= 0 to 15 do
    begin
      if(map[xpos,ypos].value = 1) and (map[xpos,ypos].ocupation = false) then
      begin
        textbackground( brown );
        textcolor( brown ) ;
        write(map[xpos,ypos].value:3);
      end
      else
      if(map[xpos,ypos].value = 2) and (map[xpos,ypos].ocupation = false) then
      begin
        textbackground( blue );
        textcolor( blue );
        write(map[xpos,ypos].value:3);
      end
      else
      if ((map[xpos,ypos].value= 1) or (map[xpos,ypos].value = 2)) and (map[xpos,ypos].ocupation = true) then
      begin
        textbackground( red );
        textcolor( red );
        write(map[xpos,ypos].value:3);
      end;
    end;
    textbackground( black );
    writeln;
  end;
end;

function playerMove(playerAux:playerType;map:mapType) : playerType;
var direction, count:integer;
begin
  randomize();
  for count:=0 to 255 do
  begin
    if (playerAux[count].be=true) then
    begin
      direction:=random(9);
      if direction = 1 then //left up
      begin
        if (playerAux[count].xpos=0) or (playerAux[count].ypos=0) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos - 1;
          playerAux[count].ypos:=playerAux[count].ypos - 1;
        end;
      end;
      if direction = 2 then //up
      begin
        if (playerAux[count].ypos=0) then //se estiver no limite superior não some
        else
        begin
          playerAux[count].ypos:=playerAux[count].ypos - 1;
        end;
      end;
      if direction = 3 then //right up
      begin
        if (playerAux[count].xpos=15) or (playerAux[count].ypos=0) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos + 1;
          playerAux[count].ypos:=playerAux[count].ypos - 1;
        end;
      end;
      if direction = 4 then //left
      begin
        if (playerAux[count].xpos=0) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos - 1;
        end;
      end;
      if direction = 5 then //right
      begin
        if (playerAux[count].xpos=15) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos +1;
        end;
      end;
      if direction = 6 then //left down
      begin
        if (playerAux[count].xpos=0) or (playerAux[count].ypos=15) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos - 1;
          playerAux[count].ypos:=playerAux[count].ypos + 1;
        end;
      end;
      if direction = 7 then //down
      begin
        if (playerAux[count].ypos=15) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].ypos:=playerAux[count].ypos + 1;
        end;
      end;
      if direction = 8 then //left up
      begin
        if (playerAux[count].xpos=15) or (playerAux[count].ypos=15) then //se estiver no limite esquerdo ou superior não some
        else
        begin
          playerAux[count].xpos:=playerAux[count].xpos + 1;
          playerAux[count].ypos:=playerAux[count].ypos + 1;
        end;
      end;
    end;
  end;
  playerMove:=playerAux;
end;

//player Morte
function playerDead(playerAux:playerStatus):playerStatus;
begin
  playerAux.be:=false;
  playerAux.comida:=0;
  playerAux.agua:=0;
  playerAux.lifeTimeCycles:=0;
  playerDead:=playerAux;
end;

//atualiza personagens, implementa recursos
function playerStatusRefresh(playerAux:playerType; map:mapType):playerType;
var count, countAux, xPosAux, yPosAux, foodCount, waterCount, randomAux, lifeTimeCycles:integer;
begin
  for count:= 0 to 255 do
  if playerAux[count].be = true then
  begin
    playerAux[count].lifeTimeCycles:=playerAux[count].lifeTimeCycles + 1;
    if (map[playerAux[count].xpos,playerAux[count].ypos].value) = 1 then
    playerAux[count].comida:=playerAux[count].comida + 1
    else
    if (map[playerAux[count].xpos,playerAux[count].ypos].value) = 2 then
    playerAux[count].agua:=playerAux[count].agua + 1;
    if (playerAux[count].comida >= 4) and (playerAux[count].agua >= 3) then
    begin
      while (playerAux[countAux].be=true) do
      begin
        countAux:=countAux + 1;
        if countAux = 255 then
        playerAux[countAux]:=playerDead(playerAux[countAux]);
      end;
      if (playerAux[count].xpos >= 15) and (randomAux = 1 ) then
      playerAux[countAux].xpos:=playerAux[count].xpos + 1
      else
      playerAux[countAux].xpos:=playerAux[count].xpos - 1;
      if (playerAux[count].xpos > 0 ) and (randomAux = 0) then
      playerAux[countAux].xpos:=playerAux[count].xpos - 1
      else
      playerAux[countAux].xpos:=playerAux[count].xpos + 1;
      playerAux[countAux].be:=true;
      countAux:=0;
      playerAux[count].comida:=0;
      playerAux[count].agua:=0;
    end;
    if (map[playerAux[count].xpos,playerAux[count].ypos].ocupation = true) or (playerAux[count].lifeTimeCycles = 18) then
    begin
      playerAux[count]:=playerDead(playerAux[count]);
    end;
  end;
  playerStatusRefresh:=playerAux;
end;
End.