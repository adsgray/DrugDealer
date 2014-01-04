Unit DrugDisplays;
Interface
Uses DrugDealData,awin;
Var MainWindow : awindow;
   
Procedure ShowDealer(InDealer : DealerInfoType);
Procedure ShowCity(InCity : CityInfoType);

Implementation
Uses bdrwin,CRT;
Var
   DealerWindow,
   CityWindow    : bdrwindow;
   
   
Procedure ShowDealer(InDealer : DealerInfoType);
Begin
   DealerWindow.Title.Contents := InDealer.Name;
   DealerWindow.Show;
   WriteLn;
   With InDealer Do Begin
      WriteLn('   Mental Health: ',Health.mental,'/30');
      WriteLn(' Physical Health: ',Health.physical,'/30');
      WriteLn;
      WriteLn('  Weapon: ',Guns[Gun].Name);
      WriteLn('  Travel: ',Tran[Trans].Name);
      WriteLn('   Money: $',Money:0:2);
   End;
End;

Procedure ShowCity(InCity : CityInfoType);
Begin
   CityWindow.Title.Contents := InCity.Name;
   CityWindow.Show;
   With InCity Do Begin
      WriteLn(' Competition: ',Competition,'/10');
      WriteLn(' Suspicion: ',Cops.Suspicion,'/10');
      WriteLn(' Customers: ',Customers);
      WriteLn(' Retail: ',Retail*100:0:0,'%');
   End;
End;

Begin
   With DealerWindow Do Begin
      init(1,1,1,26,10,White+Blue ShL 4,'DEALER');
      brdrattr := White + Red ShL 4;
   End;
   With CityWindow Do Begin
      init(0,49,1,79,11,White + Blue ShL 4,'CITY');
      brdrattr := White + Red ShL 4;
      brdrtype := 3;
   End;
   With MainWindow Do Begin
      init(0,1,13,80,25,White + Blue ShL 4);
   End;
End.
