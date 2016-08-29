% Fruits
BoatName1 = uitreenode('v0', 'Shark1', 'Shark1', [], false);
BoatName1.add(uitreenode('v0', 'Trip1',  'Trip1',  [], true));
BoatName1.add(uitreenode('v0', 'Trip2',   'Trip2',   [], true));
BoatName1.add(uitreenode('v0', 'Trip3', 'Trip3', [], true));

 %Shark1
% Vegetables
BoatName2 = uitreenode('v0', 'Shark2', 'Shark2', [], false);
BoatName2.add(uitreenode('v0', 'Trip1', 'Trip1', [], true));
BoatName2.add(uitreenode('v0', 'Trip2', 'Trip2', [], true));
BoatName2.add(uitreenode('v0', 'Trip3', 'Trip3', [], true));
 
% Root node
root = uitreenode('v0', 'Boats', 'Boats', [], false);
root.add(BoatName1);
root.add(BoatName2);
 
% Tree
figure('pos',[300,300,150,150]);
mtree = uitree('v0', 'Root', root);% 'SelectionChangeFcn',@mySelectFcn);

value=mySelectFcn(mtree);


selNodes = mtree.selectedNodes;
selNode = selNodes(1);
selNodeName = char ( selNode.getName() );
path = selNode.getPath;parentNode = char(path( (length(path))-1 ).getName); % getting the

