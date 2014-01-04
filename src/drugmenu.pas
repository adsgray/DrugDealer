Unit DrugMenus;
Interface
Uses DrugDealData,MenuB;

Var
   MDrugList, MGunList, MCarList,
   Mtravel, Mpurchase, MDrugs, MView, MFile,
   MMain : menubox;
   
Implementation Uses CRT;
Const
   MAttr = White + Blue ShL 4;
   BAttr = White + Red ShL 4;
Begin
   With MMain Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 5;
      options[1]:='Travel';
      options[2]:='Purchase';
      options[3]:='Drugs';
      options[4]:='View';
      options[5]:='File';
      barattr :=  BAttr;
      Size;
   End;
   With Mtravel Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 6;
      options[1]:=City[Windsor].Name;
      options[2]:=City[Hamilton].Name;
      options[3]:=City[Toronto].Name;
      options[4]:=City[Kingston].Name;
      options[5]:=City[Ottawa].Name;
      options[6]:=City[Cornwall].Name;
      barattr :=  BAttr;
      Size;
   End;
   With Mpurchase Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 3;
      options[1]:='Car';
      options[2]:='Gun';
      options[3]:='Drugs';
      barattr :=  BAttr;
      Size;
   End;
   With Mdrugs Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 4;
      options[1]:='Purchase';
      options[2]:='Sell';
      options[3]:='Use';
      options[4]:='Inventory';
      barattr :=  BAttr;
      Size;
   End;
   With Mview Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 3;
      options[1]:='Your stats';
      options[2]:='Current city';
      options[3]:='Drug inventory';
      barattr :=  BAttr;
      Size;
   End;
   With Mfile Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 3;
      options[1]:='Save game';
      options[2]:='Load game';
      options[3]:='Quit';
      barattr := BAttr;
      Size;
   End;
   
   {=======================================}
   
   With MDrugList Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 5;
      options[1]:=Drug[Marijuana].Name;
      options[2]:=Drug[Acid].Name;
      options[3]:=Drug[Speed].Name;
      options[4]:=Drug[Heroin].Name;
      options[5]:=Drug[Cocaine].Name;
      barattr := BAttr;
      Size;
   End;
   With MGunList Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 5;
      options[1]:=Guns[HandGun].Name;
      options[2]:=Guns[SemiAuto].Name;
      options[3]:=Guns[FullAuto].Name;
      options[4]:=Guns[Sub].Name;
      options[5]:=Guns[Assault].Name;
      barattr := BAttr;
      Size;
   End;
   With MCarList Do Begin
      init(1,30,2,5,5,MAttr);
      numoptions := 2;
      options[1]:=Tran[BadCar].Name;
      options[2]:=Tran[GoodCar].Name;
      barattr := BAttr;
      Size;
   End;
End.
