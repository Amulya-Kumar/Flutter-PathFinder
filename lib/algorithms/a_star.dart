import 'package:pathfinding_app/common/pair.dart';

class Fpair {
  double fValue;
  Pair pair = new Pair();

  void setValue(double x, Pair sPair) {
    this.fValue = x;
    pair.setValue(sPair.xCord, sPair.yCord);
  }
}

class Cell {
  int parentXCord;
  int parentYCord;

  double fValue;
  double gValue;
  double hValue;

  Cell(
      {this.parentXCord,
      this.parentYCord,
      this.fValue,
      this.gValue,
      this.hValue});
}

bool isValid(int row, int col, int rows, int cols) {
  return (row >= 0) && (row < rows) && (col >= 0) && (col < cols);
}

bool isUnBlocked(List<List<bool>> grid, int row, int col) {
  if (grid[row][col] == false)
    return true;
  else
    return false;
}

bool isDestination(int row, int col, Pair dest) {
  if (row == dest.xCord && col == dest.yCord)
    return true;
  else
    return false;
}

double calculateHValue(int row, int col, Pair dest) {
  double xValue = row.toDouble() - dest.xCord;
  double yValue = col.toDouble() - dest.yCord;
  double hValue = (xValue.abs() + yValue.abs());
  return hValue;
}

List<Pair> tracePath(List<List<Cell>> cellDetails, Pair dest) {
  int row = dest.xCord;
  int col = dest.yCord;

  List<Pair> path = new List<Pair>();

  while (!(cellDetails[row][col].parentXCord == row &&
      cellDetails[row][col].parentYCord == col)) {
    var tempPair = new Pair();
    tempPair.setValue(row, col);
    path.insert(0, tempPair);

    int tempRow = cellDetails[row][col].parentXCord;
    int tempCol = cellDetails[row][col].parentYCord;
    row = tempRow;
    col = tempCol;
  }

  var ntempPair = new Pair();
  ntempPair.setValue(row, col);
  path.insert(0, ntempPair);
  return path;
}

Pair aStarSearch(List<List<bool>> grid, Pair src, Pair dest) {
  int rows = grid.length;
  int cols = grid[0].length;

  grid[src.xCord][src.yCord] = false;
  grid[dest.xCord][dest.yCord] = false;

  if (isValid(src.xCord, src.yCord, rows, cols) == false) {
    print("Source is invalid");
    return null;
  }

  if (isValid(dest.xCord, dest.yCord, rows, cols) == false) {
    print("Destination is invalid");
    return null;
  }

  if (isDestination(src.xCord, src.yCord, dest) == true) {
    print("We are already at the destination");
    return null;
  }

  var closedList = new List.generate(
      rows, (_) => new List<bool>.filled(cols, false, growable: true));
  var orderedClosedList = new List.generate(rows, (_) => new List<int>.filled(cols, 0));
  var cellDetails = new List<List<Cell>>.generate(rows, (i) => new List<Cell>(cols));

  int i, j;

  for (i = 0; i < rows; i++) {
    for (j = 0; j < cols; j++) {
      Cell tempCell = new Cell();
      tempCell.fValue = double.infinity;
      tempCell.gValue = double.infinity;
      tempCell.hValue = double.infinity;
      tempCell.parentXCord = -1;
      tempCell.parentYCord = -1;

      cellDetails[i][j] = tempCell;
    }
  }

  i = src.xCord;
  j = src.yCord;

  cellDetails[i][j].fValue = 0.0;
  cellDetails[i][j].gValue = 0.0;
  cellDetails[i][j].hValue = 0.0;
  cellDetails[i][j].parentXCord = i;
  cellDetails[i][j].parentYCord = j;

  List<Fpair> openList = new List<Fpair>();

  var tempPair = new Pair();
  tempPair.setValue(i, j);
  var tempFpair = new Fpair();
  tempFpair.setValue(0.0, tempPair);

  openList.insert(0, tempFpair);

  bool foundDest = false;
  int counter = 0;
  while (openList.isNotEmpty) {
    counter++;
    Fpair p = new Fpair();
    p = openList[0];
    int currentIndex = 0;
    
    for(int i=0; i<openList.length; i++){
      if(openList[i].fValue < p.fValue){
        p = openList[i];
        currentIndex = i;
      }
    }
    openList.removeAt(currentIndex);

    i = p.pair.xCord;
    j = p.pair.yCord;

    closedList[i][j] = true;
    orderedClosedList[i][j] = counter;

    double gNew, hNew, fNew;
    if (isValid(i - 1, j, rows, cols)) {
      if (isDestination(i - 1, j, dest)) {
        cellDetails[i - 1][j].parentXCord = i;
        cellDetails[i - 1][j].parentYCord = j;
        print("Destination is found");
        var path = tracePath(cellDetails, dest);
        foundDest = true;
        var resultPair = new Pair();
        resultPair.setValue(path, orderedClosedList);
        return resultPair;
      } else if (closedList[i - 1][j] == false &&
          isUnBlocked(grid, i - 1, j) == true) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i - 1, j, dest);
        fNew = gNew + hNew;

        if (cellDetails[i - 1][j].fValue == double.infinity ||
            cellDetails[i - 1][j].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i - 1, j);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i - 1][j].fValue = fNew;
          cellDetails[i - 1][j].gValue = gNew;
          cellDetails[i - 1][j].hValue = hNew;
          cellDetails[i - 1][j].parentXCord = i;
          cellDetails[i - 1][j].parentYCord = j;
        }
      }
    }

    if (isValid(i, j - 1, rows, cols)) {
      if (isDestination(i, j - 1, dest)) {
        cellDetails[i][j - 1].parentXCord = i;
        cellDetails[i][j - 1].parentYCord = j;
        print("Destination is found");
        var path = tracePath(cellDetails, dest);
        foundDest = true;
        var resultPair = new Pair();
        resultPair.setValue(path, orderedClosedList);
        return resultPair;
      } else if (closedList[i][j - 1] == false && isUnBlocked(grid, i, j - 1)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i, j - 1, dest);
        fNew = gNew + hNew;

        if (cellDetails[i][j - 1].fValue == double.infinity ||
            cellDetails[i][j - 1].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i, j - 1);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i][j - 1].fValue = fNew;
          cellDetails[i][j - 1].gValue = gNew;
          cellDetails[i][j - 1].hValue = hNew;
          cellDetails[i][j - 1].parentXCord = i;
          cellDetails[i][j - 1].parentYCord = j;
        }
      }
    }

    if (isValid(i + 1, j, rows, cols)) {
      if (isDestination(i + 1, j, dest)) {
        cellDetails[i + 1][j].parentXCord = i;
        cellDetails[i + 1][j].parentYCord = j;
        print("Destination is found");
        var path = tracePath(cellDetails, dest);
        foundDest = true;
        var resultPair = new Pair();
        resultPair.setValue(path, orderedClosedList);
        return resultPair;
      } else if (closedList[i + 1][j] == false && isUnBlocked(grid, i + 1, j)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i + 1, j, dest);
        fNew = gNew + hNew;

        if (cellDetails[i + 1][j].fValue == double.infinity ||
            cellDetails[i + 1][j].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i + 1, j);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i + 1][j].fValue = fNew;
          cellDetails[i + 1][j].gValue = gNew;
          cellDetails[i + 1][j].hValue = hNew;
          cellDetails[i + 1][j].parentXCord = i;
          cellDetails[i + 1][j].parentYCord = j;
        }
      }
    }

    if (isValid(i, j + 1, rows, cols)) {
      if (isDestination(i, j + 1, dest)) {
        cellDetails[i][j + 1].parentXCord = i;
        cellDetails[i][j + 1].parentYCord = j;
        print("Destination is found");
        var path = tracePath(cellDetails, dest);
        foundDest = true;
        var resultPair = new Pair();
        resultPair.setValue(path, orderedClosedList);
        return resultPair;
      } else if (closedList[i][j + 1] == false && isUnBlocked(grid, i, j + 1)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i, j + 1, dest);
        fNew = gNew + hNew;

        if (cellDetails[i][j + 1].fValue == double.infinity ||
            cellDetails[i][j + 1].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i, j + 1);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i][j + 1].fValue = fNew;
          cellDetails[i][j + 1].gValue = gNew;
          cellDetails[i][j + 1].hValue = hNew;
          cellDetails[i][j + 1].parentXCord = i;
          cellDetails[i][j + 1].parentYCord = j;
        }
      }
    }
  }
  if (foundDest == false) print("failed to find destination");

  return null;
}

/*main() {
  var grid =
      new List.generate(5, (_) => new List<int>.filled(5, 0, growable: true));

  grid[0][2] = 1;
  grid[1][2] = 1;
  grid[2][2] = 1;

  print(grid);

  var src = new Pair(); // Creating Object
  src.setValue(1, 1);

  var dest = new Pair(); // Creating Object
  dest.setValue(0, 4);

  aStarSearch(grid, src, dest);
}*/