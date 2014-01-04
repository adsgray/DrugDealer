uses DrugDealData,DOS;
{$V-}

function fileExist(var s : string) : boolean;
begin
  fileExist := fSearch(s, '') <> '';
end;

procedure Update;
begin
    writeln;
    writeln('            You are in: ',City[Dealer.CurCity].Name,'.');
    writeln('        Your weapon is: ',GunName[Dealer.Gun],'.');
    writeln('Your mode of travel is: ',TransName[Dealer.Trans],'.');
end;

procedure SaveGame;
var
  fn : string[30];
  f  : file;
begin
  writeln;
  write('Save game to filename> ');
  readln(fn);
  if fileexist(fn) then
    write('Overwriting file...')
  else
    write('Saving File...');
  assign(f,fn);
  rewrite(f,1);
    blockwrite(f,dealer,sizeof(dealerinfotype));
    write('....');
    blockwrite(f,city,sizeof(cityarray));
    write('........');
    blockwrite(f,drug,sizeof(drugarray));
    writeln('......');
  close(f);
  writeln('Done!');
end;


procedure LoadGame;
var
  fn : string[30];
  f  : file;
begin
  writeln;
  write('Load game from filename> ');
  readln(fn);
  if not fileexist(fn) then
    writeln('File not found.')
  else begin
    write('Loading File...');
    assign(f,fn);
    reset(f,1);
      blockread(f,dealer,sizeof(dealerinfotype));
      write('....');
      blockread(f,city,sizeof(cityarray));
      write('........');
      blockread(f,drug,sizeof(drugarray));
      writeln('......');
    close(f);
    writeln('Done!');
  end;
end;

begin
 writeln('Kingston and Windsor: ',
 Distance[Kingston,Windsor],'  ',Distance[Windsor,Kingston]);
 writeln('Windsor and Cornwall: ',Distance[Windsor,Cornwall]);
 writeln('Ottawa and Windsor: ',Distance[Ottawa,Windsor]);
 writeln(Distance[Hamilton,Hamilton]);

 Update;

 Dealer.CurCity:=CornWall;
 Dealer.Gun:=FullAuto;
 Dealer.Trans := BadCar;

 Update;
 SaveGame;

 Dealer.CurCity := Toronto;
 Dealer.Gun:=SemiAuto;
 Dealer.Trans:=GoodCar;

 Update;
 LoadGame;
 Update;
end.
