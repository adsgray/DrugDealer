{$V-}
Uses
   DrugDealData, DrugMenus, DrugDisplays,
   CursorControl,
   Crt, Dos;

{========= FILE PROCEDURES 1 ==============================================}
Function fileExist(Var s : String) : Boolean;
Begin
   fileExist := FSearch(s, '') <> '';
End;

Procedure ForceExt(Var filename: String; EXT: String);
{ forces extension of EXT onto filename }
Var
   Index,
   ExtLength : Integer;
   
Begin
   If Pos('.',filename)=0 Then
      filename:=filename+'.'+EXT
   Else
   Begin
      Index:=Pos('.',filename);
      ExtLength:=Length(filename)-Index;
      Delete(filename,Index,ExtLength+1);
      filename:=filename+'.'+EXT;
   End; {else}
End; {ForceExt}
{==========================================================================}

Procedure writesnd(InString : String);
Var tc : Byte;
Begin
   For tc := 1 To Length(InString) Do Begin
      Write(InString[tc]);
      Sound(550); Delay(15); NoSound; Delay(10);
   End;
End;

Const origmode:Word = 3;
Procedure InitScreen;
Begin
   If LastMode <> c80 Then Begin
      origmode := LastMode;
      TextMode(c80);
   End;
   TextBackground(Cyan); ClrScr;
   MainWindow.Show;
   MainWindow.Shrink(1);
   Mmain.show;
   ShowDealer(Dealer);
   ShowCity(City[Dealer.CurCity]);
   MainWindow.Current;
   Write('Enter Your Name> ');
   ReadLn(Dealer.Name);
   MainWindow.SavePos;
   Cursor_Off;
   ShowDealer(Dealer);
End;

Procedure Done;
Begin
   Cursor_On;
   TextMode(origmode);
   Halt(0);
End;

Procedure Mw;
Begin
   MainWindow.Current;
   MainWindow.ResPos;
   Cursor_On;
   ReadLn;
   MainWindow.SavePos;
   Cursor_Off;
End;

Const CR = #10#13; {writeln}
   
   
{============ FILE PROCEDURES 2 ===========================================}
Procedure SaveGame;
Var
   fn : String[30];
   f  : File;
Begin
   Cursor_On;
   mainwindow.current;
   mainwindow.respos;
   Write('Save game to filename> ');
   ReadLn(fn);
   If fn <> '' Then Begin
      forceext(fn,'DRG');
      If fileexist(fn) Then
         Write('Overwriting file...')
      Else
         Write('Saving File...');
      Assign(f,fn);
      Rewrite(f,1);
      BlockWrite(f,dealer,SizeOf(dealerinfotype));
      Write('....');
      BlockWrite(f,city,SizeOf(cityarray));
      Write('........');
      BlockWrite(f,drug,SizeOf(drugarray));
      WriteLn('......');
      Close(f);
      WriteLn('Done!');
   End;
   mainwindow.savepos;
   Cursor_Off;
End;


Procedure LoadGame;
Var
   fn : String[30];
   f  : File;
Begin
   Cursor_On;
   mainwindow.current;
   mainwindow.respos;
   Write('Load game from filename> ');
   ReadLn(fn);
   forceext(fn,'DRG');
   If Not fileexist(fn) Then Begin
      WriteLn('File not found.');
      mainwindow.savepos;
   End
   Else Begin
      Write('Loading File...');
      Assign(f,fn);
      Reset(f,1);
      BlockRead(f,dealer,SizeOf(dealerinfotype));
      Write('....');
      BlockRead(f,city,SizeOf(cityarray));
      Write('........');
      BlockRead(f,drug,SizeOf(drugarray));
      WriteLn('......');
      Close(f);
      WriteLn('Done!');
      mainwindow.savepos;
      ShowDealer(Dealer);
      ShowCity(City[Dealer.CurCity]);
   End;
   Cursor_Off;
End;
{==========================================================================}

Procedure BuyCar;
Var choice:Byte;
Begin
   MCarList.Show;
   choice := MCarList.Choose(True);
   If (choice <> 0) And (Dealer.Trans < TransType(choice)) Then Begin
      MainWindow.Current;
      MainWindow.ResPos;
      TextColor(Yellow);
      WriteLn('You buy a '+Tran[TransType(choice)].Name+'.');
      MainWindow.SavePos;
      Dealer.Money := Dealer.Money - Tran[TransType(choice)].Cost;
      Dealer.Trans := TransType(choice);
      showdealer(dealer);
   End;
   MCarList.Hide(Cyan);
End;

Procedure BuyGun;
Var choice:Byte;
Begin
   MGunList.Show;
   choice := MGunList.Choose(True);
   If (choice <> 0) And (Dealer.Gun < GunType(choice-1)) Then Begin
      MainWindow.Current;
      MainWindow.ResPos;
      TextColor(Yellow);
      WriteLn('You buy a gun: '+Guns[GunType(choice-1)].Name+'.');
      MainWindow.SavePos;
      Dealer.Money := Dealer.Money - Guns[GunType(choice-1)].Cost;
      Dealer.Gun := GunType(choice-1);
      showdealer(dealer);
   End;
   MGunList.Hide(Cyan);
End;

Procedure BuyDrug;
Var
   choice:Byte;
   units:Byte;
   ACost:Real; {actual cost}
Begin
   MDrugList.Show;
   choice := MDrugList.Choose(True);
   If (choice <> 0) Then Begin
      Randomize;
      ACost := Drug[DrugType(choice-1)].BaseCost *
      (1 + (Random(1)/2 + City[Dealer.CurCity].competition/20));
      MainWindow.Current;
      MainWindow.Respos;
      Cursor_On;
      Write('Number of units to buy ('+Drug[DrugType(choice-1)].Name+')> ');
      ReadLn(units);
      MainWindow.Savepos;
      Cursor_Off;
      Inc(Dealer.Inventory[DrugType(choice-1)],units);
      Dealer.Money := Dealer.Money - (units * ACost);
      showdealer(dealer);
   End;
   MDrugList.Hide(Cyan);
End;

Procedure SellDrug;
Var choice:Byte;
   NSold : Word;
   ACost : Real;
   st    : String[6];
Begin
   MDrugList.Show;
   choice := MDrugList.Choose(True);
   If (choice <> 0) And (Dealer.Inventory[drugtype(choice-1)] > 0) Then Begin
      Randomize;
      Repeat
         With City[Dealer.CurCity] Do NSold := Abs((Random(customers) - Random(competition)))
            + Random(Ord(dealer.gun));
      Until NSold <= Dealer.Inventory[DrugType(choice-1)];
      ACost := Drug[DrugType(choice-1)].BaseCost * City[Dealer.CurCity].Retail;
      Dec(Dealer.Inventory[DrugType(choice-1)],NSold);
      Dealer.Money := Dealer.Money + (NSold * ACost);
      MainWindow.Current;
      MainWindow.ResPos;
      Cursor_On;
      Str(NSold,st);
      TextColor(Yellow);
      WriteLn('You manage to sell '+st+' unit(s) of '+drug[drugtype(choice-1)].Name+'.');
      MainWindow.Savepos;
      Cursor_Off;
      ShowDealer(Dealer);
   End;
   MDrugList.hide(Cyan);
End;

Procedure UseDrug;
Var choice:Byte;
Begin
   MDrugList.Show;
   choice := MDrugList.Choose(True);
   If (choice <> 0) And (Dealer.Inventory[drugtype(choice-1)] > 0) Then Begin
      Inc(City[Dealer.CurCity].customers,Ord(drugtype(choice-1))+1);
      Dec(Dealer.Inventory[drugtype(choice-1)],1);
      With Dealer.Health Do Begin
         Dec(Mental,Drug[drugtype(choice-1)].det.mental);
         Dec(Physical,Drug[drugtype(choice-1)].det.Physical);
      End;
      MainWindow.Current;
      mainwindow.respos;
      TextColor(Yellow);
      WriteLn('You use some of your ',Drug[drugtype(choice-1)].Name,'.');
      mainwindow.savepos;
      ShowDealer(Dealer);
      ShowCity(City[Dealer.CurCity]);
   End;
   MDrugList.Hide(Cyan);
End;

Procedure DealerStat;
Procedure HGraph(InNum : Byte);
Var ct : Byte;
Begin
   For ct := 1 To InNum Do Write(#219);
   For ct := 1 To (30 - InNum) Do Write(#177);
   WriteLn(' ',InNum/30*100:0:1,'%');
End;

Begin
   MainWindow.Current;
   MainWindow.ResPos;
   TextColor(Yellow);
   With Dealer Do Begin
      Write('Dealer: ');
      TextColor(White);
      WriteLn(Name);
      WriteLn('Money: $',Money:0:2);
      WriteLn('Health...');
      Write('  Mental: ');
      HGraph(Health.Mental);
      Write('Physical: ');
      HGraph(Health.Physical);
   End;
   MainWindow.SavePos;
End;

Procedure CityStat;
Begin
   MainWindow.Current;
   MainWindow.ResPos;
   TextColor(Yellow);
   WriteLn(City[Dealer.CurCity].Name,':');
   With City[Dealer.CurCity] Do Begin
      TextColor(White);
      WriteLn('Retail Factor: ',Retail:0:2);
      WriteLn('Cops...');
      With Cops Do Begin
         WriteLn('Suspicion: ',Suspicion,'/10');
         WriteLn('Gun: ',Guns[Gun].Name);
         WriteLn('Minimum Bribe: $',Bribe:0:2);
         Case Bribed Of
            True : WriteLn('Bribed.');
            False: WriteLn('Not Bribed.');
         End;
      End;
   End;
   MainWindow.SavePos;
End;

Procedure DrugInv;
Var dc:drugtype;
Begin
   MainWindow.Current;
   MainWindow.ResPos;
   TextColor(Yellow);
   WriteLn('Drug Inventory: ');
   TextColor(White);
   With Dealer Do Begin
      For dc := Marijuana To Cocaine Do
         If Inventory[dc] > 0 Then
            WriteLn(Drug[dc].Name,': ',Inventory[dc]);
   End;
   MainWindow.SavePos;
End;

Procedure ImproveHealth; Begin
   With Dealer.Health Do Begin
      If Mental < 20 Then Inc(Mental,Random(3)+1+Ord(Dealer.CurCity));
      If Physical < 20 Then Inc(Physical,Random(3)+1+Ord(Dealer.CurCity));
   End;
   ShowDealer(Dealer);
   ShowCity(City[Dealer.CurCity]);
End;

Procedure DoCops;
Var
   chance:Byte;
   t,
   choice : Char;
   
Procedure Lose;
Var dc:drugtype;
Begin
   TextColor(White);
   WriteLn('All of your possessions are confiscated as "evidence"...');
   With Dealer Do Begin
      Gun := GunType(0);
      Trans := TransType(0);
      If money > 0 Then money := 0;
      For dc := marijuana To cocaine Do inventory[dc] := 0;
   End;
   If City[Dealer.CurCity].cops.suspicion + 1 <= 10 Then
      Inc(City[Dealer.CurCity].cops.suspicion);
End;

Begin
   cursor_on;
   Randomize;
   chance := Random(12 - city[dealer.curcity].cops.suspicion);
   mainwindow.current;
   mainwindow.respos;
   If chance = 2 Then Begin
      TextColor(LightRed);
      WriteLn('The police arrest you!');
      TextColor(White);
      If dealer.money >= city[dealer.curcity].cops.bribe Then Begin
         WriteLn('You can afford to bribe them.');
         Write('Do you want to attempt it? [Y/n]');
         Repeat
            choice := UpCase(ReadKey);
            If choice = #0 Then t := ReadKey;
         Until choice In ['Y','N',#13];
         WriteLn;
         If choice = #13 Then choice := 'Y';
         If choice = 'Y' Then Begin
            chance := Random(3) + 1;
            If chance <> 2 Then Begin
               WriteLn('The cops accept your offer!');
               WriteLn('You will have to pay them $',City[Dealer.CurCity].cops.bribe:0:2,
               ' each time you return.');
               Dealer.Money := Dealer.Money - City[Dealer.CurCity].cops.bribe;
               City[Dealer.CurCity].cops.bribed := True;
            End
            Else Begin
               TextColor(LightRed);
               WriteLn('The cops don''t accept your offer!');
               Lose;
            End;
         End
         Else Lose;
      End
      Else Begin
         TextColor(LightRed);
         WriteLn('You can''t afford a bribe! ($',city[dealer.curcity].cops.bribe:0:2,')');
         Lose;
      End;
   End
   Else Begin
      TextColor(LightGreen);
      WriteLn('You have no trouble from the police in ',City[Dealer.CurCity].Name,'.');
   End;
   mainwindow.savepos;
   cursor_off;
End;

Procedure Travel;
Var choice1:Byte;
Begin
   Mtravel.show;
   choice1 := Mtravel.choose(True);
   If choice1 <> 0 Then Begin
      Case Dealer.Trans Of
         Foot : Dealer.Money := Dealer.Money -
            (Distance[Dealer.CurCity,CityType(Choice1-1)]*BusF);
         BadCar : Dealer.Money := Dealer.Money -
            (Distance[Dealer.CurCity,CityType(Choice1-1)]*GasF);
         GoodCar : Dealer.Money := Dealer.Money -
            (Distance[Dealer.CurCity,CityType(Choice1-1)]*(GasF-Random(3)+1));
      End;
      Dealer.CurCity := CityType(choice1 - 1);
      City[Dealer.CurCity].customers := Random(10) + 5;
      If City[Dealer.CurCity].Cops.bribed Then Dealer.Money := Dealer.Money
         - City[Dealer.CurCity].Cops.bribe 
      Else DoCops;
   End;
   Mtravel.hide(Cyan);
End;


Var choice1:Byte;
Begin {MAIN}
   InitScreen;
   Repeat
      choice1 := Mmain.choose(False);
      Mmain.hide(Cyan);
      Case choice1 Of
         1 : 
         Begin {Travel}
            Travel;
            ImproveHealth;
            MMain.show;
         End;
         2 : 
         Begin {Purchase}
            Mpurchase.show;
            Case Mpurchase.choose(True) Of
               1: {Car} 
               Begin
                  Mpurchase.hide(Cyan);
                  Buycar;
                  ImproveHealth;
               End;
               2: {Gun} 
               Begin
                  Mpurchase.hide(Cyan);
                  Buygun;
                  ImproveHealth;
               End;
               3: {Drugs} 
               Begin
                  Mpurchase.hide(Cyan);
                  Buydrug;
                  ImproveHealth;
               End;
            End;
            MMain.show;
         End;
         3 : 
         Begin {Drugs}
            Mdrugs.show;
            Case Mdrugs.choose(True) Of
               1: {Buy} 
               Begin
                  Mdrugs.hide(Cyan);
                  Buydrug;
                  ImproveHealth;
               End;
               2: {Sell} 
               Begin
                  Mdrugs.hide(Cyan);
                  SellDrug;
                  ImproveHealth;
               End;
               3: {Use} 
               Begin
                  Mdrugs.hide(Cyan);
                  UseDrug;
               End;
               4: {Inventory} 
               Begin
                  Mdrugs.hide(Cyan);
                  DrugInv;
               End;
               Else MDrugs.hide(Cyan);
            End;
            MMain.show;
         End;
         4 : 
         Begin {View}
            Mview.show;
            Case Mview.choose(True) Of
               1: {Your stats} DealerStat;
               2: {Current City} CityStat;
               3: {Drug Inventory} DrugInv;
            End;
            Mview.hide(Cyan);
            MMain.show;
         End;
         5 : 
         Begin {File}
            Mfile.show;
            Case Mfile.choose(True) Of
               1: SaveGame;
               2: LoadGame;
               3: Done;
            End;
            Mfile.hide(Cyan);
            MMain.show;
         End;
      End; {case}
   Until False;
   Done;
End.
