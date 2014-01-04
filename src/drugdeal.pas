Unit DrugDealData; {  ?  }
Interface
Type
   GunType = (HandGun, SemiAuto, FullAuto, Sub, Assault);
   GunInfo = Record
      Name : String[20];
      Cost : Real;
   End;
   GunArray = Array [GunType] Of GunInfo;
   
   CityType = (Windsor, Hamilton, Toronto, Kingston, Ottawa, Cornwall);
   
   CopInfo = Record
      Suspicion : 1..10; {scale}
      Bribe     : Real;  {bribe to pay}
      Bribed    : Boolean; {have you bribed them yet?}
      Gun       : GunType; {strength}
   End;
   
   CityInfoType = Record
      Name        : String[10]; {actual name of city}
      Cops        : CopInfo;
      Competition : 1..10; {scale}
      Customers   : Byte;
      Retail      : Real;  {factor}
   End;
   
   CityArray = Array [CityType] Of CityInfoType;
   
   DistTable = Array[CityType,CityType] Of Byte;
   {table of ditances between cities}
   
   HealthType = Record
      Mental,
      Physical : 0..30;
   End;
   
   DrugType = (Marijuana, Acid, Speed, Heroin, Cocaine);
   
   DrugInfoType = Record
      Name     : String[20]; {actual name of the drug}
      Det      : HealthType; {deterioration/effects of the drug}
      BaseCost : Real; {wholesale}
   End;
   
   DrugArray = Array [DrugType] Of DrugInfoType;
   
   TransType = (Foot, BadCar, GoodCar);
   
   TransInfo = Record
      Name : String[15];
      Cost : Real;
   End;
   
   TransArray = Array [TransType] Of TransInfo;
   
   DealerInfoType = Record
      Name      : String[20];
      CurCity   : CityType; {where you are}
      Health    : HealthType;
      Gun       : GunType;
      Trans     : TransType;
      {    IsDone,
      IsDealt   : array [DrugType] of Boolean; }
      Inventory : Array [DrugType] Of Word;
      Money     : Real; {your supply of cash}
   End;
   
Const
   GasF = 7; {multiply distance by this to get cost of driving}
   {subtract <ord(dealer.trans)> (better car = better mileage}
   BusF = 5; { " train/bus...}
   
   
Var
   Dealer   : DealerInfoType; {^DealerInfoType;}
   City     : CityArray;
   Drug     : DrugArray;
   Distance : DistTable;
   Guns     : GunArray;
   Tran     : TransArray;
   
Implementation
Procedure InitDealer(Var InDealer : DealerInfoType);
{Initialize dealer}
Var tc : DrugType; {temp counter}
Begin
   With InDealer Do Begin
      With Health Do Begin
         Mental:=30;
         Physical:=30;
      End;
      Name := 'Default';
      CurCity := Kingston;
      Trans := Foot;
      Gun:=HandGun;
      { IsDone[Marijuana]:=True;
      IsDealt[Marijuana]:=True; }
      Inventory[Marijuana]:=15;
      For tc:=Acid To Cocaine Do Begin
         {IsDealt[tc]:=False;
         IsDone[tc]:=False;}
         Inventory[tc]:=0;
      End;
      Money:=50; {	?  }
   End;
End;

Procedure InitCities(Var InCities : CityArray);
{Initalize a/the City Array...}
Begin
   With InCities[Windsor] Do Begin
      Name := 'Windsor'; Competition := 7;
      Customers := 0; Retail := 1.3;
      With Cops Do Begin
         Suspicion := 6; Bribe := 40;
         Gun := SemiAuto; Bribed := False;
      End;
   End;
   With InCities[Toronto] Do Begin
      Name := 'Toronto'; Competition := 7;
      Customers := 0; Retail := 1.2;
      With Cops Do Begin
         Suspicion := 7; Bribe := 60;
         Gun := FullAuto; Bribed := False;
      End;
   End;
   With InCities[Hamilton] Do Begin
      Name := 'Hamilton'; Competition := 6;
      Customers := 0; Retail := 1.3;
      With Cops Do Begin
         Suspicion := 6; Bribe := 32;
         Gun := FullAuto; Bribed := False;
      End;
   End;
   With InCities[Kingston] Do Begin
      Name := 'Kingston'; Competition := 3;
      Customers := 5; Retail :=1.6;
      With Cops Do Begin
         Suspicion := 4; Bribe := 10;
         Gun := HandGun; Bribed := False;
      End;
   End;
   With InCities[Ottawa] Do Begin
      Name := 'Ottawa'; Competition := 5;
      Customers := 0; Retail := 1.4;
      With Cops Do Begin
         Suspicion := 6; Bribe := 40;
         Gun := FullAuto; Bribed:=False;
      End;
   End;
   With InCities[Cornwall] Do Begin
      Name := 'Cornwall'; Competition := 4;
      Customers := 0; Retail := 2;
      With Cops Do Begin
         Suspicion := 5; Bribe := 15;
         Gun := SemiAuto; Bribed := False;
      End;
   End;
End;

Procedure InitDistTable(Var InTable : DistTable);
Var
   t1, t2 : citytype;
Begin
   For t1 := Windsor To Cornwall Do
      For t2 := Windsor To Cornwall Do
         InTable[t1,t2]:=Abs(Ord(t1)-Ord(t2));
End;

Procedure InitDrugs(Var InDrugs : DrugArray);
Begin
   With InDrugs[Marijuana] Do Begin
      Name := 'Marijuana'; BaseCost := 3;
      With Det Do Begin
         Mental := 5;  Physical := 3;
      End;
   End;
   With InDrugs[Acid] Do Begin
      Name := 'Acid'; BaseCost := 7;
      With Det Do Begin
         Mental := 9;  Physical := 6;
      End;
   End;
   With InDrugs[Speed] Do Begin
      Name := 'Speed'; BaseCost := 15;
      With Det Do Begin
         Mental := 12; Physical := 9;
      End;
   End;
   With InDrugs[Heroin] Do Begin
      Name := 'Heroin'; BaseCost := 20;
      With Det Do Begin
         Mental := 15; Physical := 22;
      End;
   End;
   With InDrugs[Cocaine] Do Begin
      Name := 'Cocaine'; BaseCost := 25;
      With Det Do Begin
         Mental := 20;  Physical := 16;
      End;
   End;
End;

Procedure InitGuns(Var InGuns : GunArray);
Begin
   With InGuns[HandGun] Do Begin
      Name := 'Hand Gun';
      Cost := 22;
   End;
   With InGuns[SemiAuto] Do Begin
      Name := 'Semi Automatic';
      Cost := 38;
   End;
   With InGuns[FullAuto] Do Begin
      Name := 'Full Automatic';
      Cost := 68;
   End;
   With InGuns[Sub] Do Begin
      Name := 'Uzi';
      Cost := 97;
   End;
   With InGuns[Assault] Do Begin
      Name := 'M16';
      Cost := 164;
   End;
End;

Procedure InitTrans(Var InTrans : TransArray);
Begin
   With InTrans[Foot] Do Begin
      Name := 'Foot';
      Cost := 0;
   End;
   With InTrans[BadCar] Do Begin
      Name := 'Volkswagon';
      cost := 548;
   End;
   With InTrans[GoodCar] Do Begin
      Name := 'Ferrari';
      cost := 1327;
   End;
End;

Begin
   {
   New(Dealer);
   New(City);
   New(Drug);
   New(Distance);
   InitDealer(Dealer^);
   InitCities(City^);
   InitDrugs(Drug^);
   InitDistTable(Distance^);
   }
   InitGuns(Guns);
   InitDealer(Dealer);
   InitCities(City);
   InitDrugs(Drug);
   InitDistTable(Distance);
   InitTrans(Tran);
End. {of unit}
