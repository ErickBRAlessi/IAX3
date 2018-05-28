Program IAX1;
uses graph, Resources; //necessário para parte gráfica // biblioteca de comandos e funções para simplicar o entendimento do aplicativo
var mapAux: mapType; player: playerType; nPlayerString:string; being, aux, nPlayer, cycle, count, xpos, ypos:integer; move : boolean;
Begin
  //cria jogador
  randomize();
  repeat
    begin
      writeln('Quantos players começam?');
      readln(nPlayerString);
      val(nPlayerString,nPlayer,aux);
      if (nPlayer>255) then
      aux:=1;
      nPlayer:=nPlayer - 1;
    end;
  until (aux=0);
  for count:=0 to nPlayer do
  begin
    player[count].be:=true;
    player[count].xpos:=random(16);
    player[count].ypos:=random(16);
  end;
  //gera mapa
  mapAux:=mapGen();
  //atualiza mapa
  while move = false do
  begin
    //move personagem
    player:=playerMove(player,mapAux);
    player:=playerStatusRefresh(player,mapAux);
		clrscr;
    mapRefresh(mapAux,player);
    cycle:=cycle + 1;
    delay(75);
    for count:=0 to 255 do
    if player[count].be = true then
    being:= being + 1;
    textcolor( white );
    writeln('Gerações : ', cycle);
    writeln('Seres    : ', being);
    being:=0;
  end;
End.