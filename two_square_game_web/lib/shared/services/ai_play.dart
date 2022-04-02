// void aiPlayLogic(){
//     print(availableGame);
//     Random ran = Random();
//     // print(testList);
//     // Random random = Random();
//     // int indexOfAvalibleGame = random.nextInt(availableGame.length);
//     // _action(availableGame[indexOfAvalibleGame][0],
//     //     availableGame[indexOfAvalibleGame][1]);

//     // availableGame.clear();

//     /*
//     easy mode 
//     Random ran = Random();
//     int index = ran.nextInt(totalGameNum);
//     int index2 = ran.nextInt(4);
//     print(
//         "first action : $index || Second Action : ${testList[index][index2]}");
//     if (testList[index][index2] != 0) {
//       _action(index + 1, testList[index][index2]);
//     } else {
//       aiPlay();
//       return;
//     }*/
//     int wait = 0;
//     if (first) {
//       wait = ran.nextInt(1000) + 1000;
//     }
//     Future.delayed(Duration(milliseconds: wait)).then((_) {
//       bool played = false;
//       for (int x = 0; x < totalGameNum; x++) {
//         int turns = 0;
//         int numY = 0;
//         for (int y = 0; y < 4; y++) {
//           if (availableGame[x][y] != 0) {
//             turns++;
//             numY = availableGame[x][y];
//           }
//         }
//         if (turns == 1) {
//           int num2 = 0;
//           getZ:
//           for (int z = 0; z < 4; z++) {
//             if (availableGame[numY - 1][z] != 0 &&
//                 availableGame[numY - 1][z] != x + 1) {
//               num2 = availableGame[numY - 1][z];
//               break getZ;
//             }
//           }
//           if (num2 != 0) {
//             _action(numY, num2);
//             played = true;
//             break;
//           }
//         }
//       }
//       if (!played) {
//         int index = ran.nextInt(totalGameNum);
//         int index2 = ran.nextInt(4);
//         print(
//             "first action : $index || Second Action : ${availableGame[index][index2]}");
//         if (availableGame[index][index2] != 0) {
//           _action(index + 1, availableGame[index][index2]);
//         } else {
//           aiPlay(first: false);
//           return;
//         }
//       }
//     });
//   }
// }