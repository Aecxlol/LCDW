L'addon est composé de 2 Cadres (Général et Options)

frame Général (3 layers du plus bas au plus haut)

1 - frame LCDWFrame qui hérite de UIParent et qui contient le cadre principal

2 - frame LCDWFrame.backgroundContainerFrame qui hérite de LCDWFrame qui contient contenir :
    - le background LCDWFrame.backgroundContainerFrame.mainBackground
    - le cadre de la fenêtre du titre Général LCDWFrame.backgroundContainerFrame.titleContainerFrame
    - le bouton pour fermer la fenêtre LCDWFrame.backgroundContainerFrame.CloseButton
    - la flèche qui ouvre et ferme la frame Options LCDWFrame.backgroundContainerFrame.openOptionsFrameButton

3 - frame LCDWFrame.backgroundContainerFrame.allElementsContainerFrame qui hérite de LCDWFrame et qui contient :
    - le cadre + flèche + titre "Guides PVE" "Guides PVP"
    - la liste des donjons et des classes

frame Options

WIP


SI UN GUILDE EST AJOUTÉ IL FAUT METTRE A JOUR LA TABLE foldersItemsNb (ligne 94 dans le lua)