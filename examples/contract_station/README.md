# Ultimate Light Rail — API Examples 1.0.0

Zelfstandige, optionele assetmod. Vereist **Ultimate Light Rail 1.0.0 / revision 49**. De hoofdmod is niet afhankelijk van dit voorbeeld.

## Ontwerpen

- **ULR Component Kit Example**: surface, doorgaand/kopstation, 40/60/80/100/120m, Covered/Minimal. Covered gebruikt eigen 20m-perron- en dakwrappers zonder hokjes/groen. Minimal laat daarnaast kap, bankjes, bakken en lampen weg.
- **ULR Contract Example**: vast bovengronds doorgaand 80m-station dat één perronmodel vervangt via modelrollen.

Beide constructionbeschrijvingen gebruiken de publieke menuhelper. Ze verschijnen in hetzelfde Light Rail-menu als de standaardstations. Vaste trap- en passtukken blijven van de kern. De modelwrappers verwijzen naar geïnstalleerde native resources; er worden geen native mesh-/texturebinaries meegeleverd.

## Eigen assetmod

Kopieer dit voorbeeld en wijzig mod-ID, zichtbare namen en alle eigen namespaceverwijzingen. Behoud de verplichte dependency op core revision 49. Gebruik het componentenvoorbeeld als startpunt; vervang de modellen door eigen 20m-assets en test je ontwerp in de game.

Lees de developer kit voor vaste maten en grenzen. Installeer de volledige hoofdmod om het voorbeeld te gebruiken. Bouw het aparte voorbeeldarchief met `python scripts/package_contract_example.py`.
