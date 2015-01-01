require 'calculate_fdi'

local filePath = './fdi/fixtures/graphs_of_interest.txt'
--local filePath = './fixtures/graphs_of_interest.txt'

local matlab = {
[1] = { [1] = {136, 3}, [2] = {137, 3}, [3] = {138, 3}, [4] = {139, 3}, [5] = {140, 3}, [6] = {261, 2}, [7] = {262, 2}, [8] = {263, 2}, [9] = {264, 2}, [10] = {265, 2}, [11] = {266, 2}, [12] = {267, 2}, [13] = {268, 2}, [14] = {269, 2}, [15] = {270, 2}, [16] = {271, 2}, [17] = {272, 2}, [18] = {273, 2}, [19] = {274, 2}, [20] = {275, 2}, [21] = {276, 2}, [22] = {277, 2}, [23] = {278, 2}, [24] = {279, 2}, [25] = {280, 2}, [26] = {281, 2}, [27] = {282, 1}, [28] = {283, 2}, [29] = {284, 2}, [30] = {285, 2}, [31] = {1602, 3}, [32] = {1603, 3}, [33] = {1604, 3}, [34] = {1605, 3}, [35] = {1606, 3}, [36] = {1607, 3}, [37] = {1608, 3}, [38] = {1609, 3}, [39] = {1610, 3}, [40] = {1611, 3}, [41] = {1612, 3}, [42] = {1613, 3}, [43] = {1614, 3}, [44] = {1615, 3}, [45] = {1616, 3}, [46] = {1617, 3}, [47] = {1618, 3}, [48] = {1619, 3}, [49] = {1620, 3}, [50] = {1621, 3}, [51] = {1622, 3}, [52] = {1623, 3}, [53] = {1624, 3}, [54] = {1625, 3}, [55] = {1626, 3}, [56] = {2094, 3}},
[2] = { [1] = {137, 2}, [2] = {138, 2}, [3] = {139, 2}, [4] = {140, 2}, [5] = {208, 1}, [6] = {223, 2}, [7] = {262, 1}, [8] = {263, 1}, [9] = {264, 1}, [10] = {265, 1}, [11] = {266, 1}, [12] = {267, 1}, [13] = {268, 1}, [14] = {269, 1}, [15] = {270, 1}, [16] = {271, 1}, [17] = {272, 1}, [18] = {273, 1}, [19] = {274, 1}, [20] = {275, 1}, [21] = {276, 1}, [22] = {277, 1}, [23] = {278, 1}, [24] = {279, 1}, [25] = {280, 1}, [26] = {281, 1}, [27] = {581, 2}, [28] = {989, 1}, [29] = {990, 1}, [30] = {991, 1}, [31] = {998, 1}, [32] = {999, 1}, [33] = {1005, 1}, [34] = {1603, 1}, [35] = {1604, 1}, [36] = {1605, 1}, [37] = {1606, 1}, [38] = {1607, 1}, [39] = {1608, 2}, [40] = {1609, 2}, [41] = {1610, 2}, [42] = {1611, 2}, [43] = {1612, 2}, [44] = {1613, 2}, [45] = {1614, 2}, [46] = {1615, 2}, [47] = {1616, 2}, [48] = {1617, 2}, [49] = {1618, 2}, [50] = {1619, 2}, [51] = {1620, 2}, [52] = {1621, 2}, [53] = {1622, 2}, [54] = {1623, 2}, [55] = {1624, 1}, [56] = {1625, 1}, [57] = {1626, 1}, [58] = {1722, 1}, [59] = {1727, 1}, [60] = {1729, 1}, [61] = {1734, 1}, [62] = {1735, 1}, [63] = {1736, 1}, [64] = {1737, 1}, [65] = {1738, 1}, [66] = {1739, 1}, [67] = {1740, 1}, [68] = {1741, 1}},
[3] = { [1] = {60, 2}, [2] = {64, 2}, [3] = {65, 2}, [4] = {79, 2}, [5] = {80, 2}, [6] = {81, 2}, [7] = {82, 2}, [8] = {103, 2}, [9] = {104, 2}, [10] = {127, 2}, [11] = {128, 2}, [12] = {129, 2}, [13] = {130, 2}, [14] = {151, 2}, [15] = {154, 2}, [16] = {208, 2}, [17] = {617, 1}, [18] = {618, 1}, [19] = {641, 1}, [20] = {642, 1}, [21] = {884, 2}, [22] = {885, 1}, [23] = {886, 1}, [24] = {908, 2}, [25] = {1004, 2}, [26] = {1056, 1}, [27] = {1075, 2}, [28] = {1076, 2}, [29] = {1148, 2}, [30] = {1172, 2}, [31] = {1200, 2}, [32] = {1224, 1}, [33] = {1267, 2}, [34] = {1268, 2}, [35] = {1296, 1}, [36] = {1315, 2}, [37] = {1340, 2}, [38] = {1342, 2}, [39] = {1343, 2}, [40] = {1388, 2}, [41] = {1464, 1}, [42] = {1603, 2}, [43] = {1604, 2}, [44] = {1605, 1}, [45] = {1606, 1}, [46] = {1699, 2}, [47] = {1918, 2}, [48] = {1955, 2}, [49] = {1989, 1}, [50] = {1990, 1}, [51] = {1991, 1}, [52] = {1992, 1}, [53] = {1993, 1}, [54] = {2038, 1}, [55] = {2039, 1}, [56] = {2040, 1}, [57] = {2041, 1}, [58] = {2050, 1}, [59] = {2051, 1}, [60] = {2057, 1}, [61] = {2096, 2}, [62] = {2099, 2}, [63] = {2103, 2}, [64] = {2110, 2}, [65] = {2111, 2}, [66] = {2124, 2}, [67] = {2125, 2}, [68] = {2144, 2}},
[4] = { [1] = {250, 2}, [2] = {251, 2}, [3] = {252, 2}, [4] = {604, 2}, [5] = {829, 3}, [6] = {1325, 1}, [7] = {1326, 1}, [8] = {1327, 1}, [9] = {1328, 1}, [10] = {1566, 2}, [11] = {1955, 3}, [12] = {2139, 3}},
[5] = { [1] = {136, 2}, [2] = {137, 2}, [3] = {138, 2}, [4] = {139, 2}, [5] = {140, 2}, [6] = {205, 1}, [7] = {206, 2}, [8] = {208, 1}, [9] = {209, 1}, [10] = {210, 1}, [11] = {211, 1}, [12] = {212, 1}, [13] = {214, 1}, [14] = {217, 1}, [15] = {219, 1}, [16] = {220, 1}, [17] = {221, 1}, [18] = {222, 1}, [19] = {223, 1}, [20] = {224, 1}, [21] = {229, 1}, [22] = {230, 1}, [23] = {231, 1}, [24] = {232, 1}, [25] = {233, 1}, [26] = {234, 1}, [27] = {235, 1}, [28] = {236, 1}, [29] = {238, 1}, [30] = {239, 1}, [31] = {240, 1}, [32] = {241, 1}, [33] = {242, 1}, [34] = {243, 1}, [35] = {244, 1}, [36] = {273, 2}, [37] = {274, 2}, [38] = {275, 2}, [39] = {276, 2}, [40] = {277, 2}, [41] = {278, 2}, [42] = {279, 1}, [43] = {987, 2}, [44] = {988, 2}, [45] = {989, 2}, [46] = {990, 2}, [47] = {991, 2}, [48] = {992, 2}, [49] = {994, 1}, [50] = {997, 1}, [51] = {998, 1}, [52] = {999, 1}, [53] = {1000, 1}, [54] = {1001, 1}, [55] = {1002, 1}, [56] = {1004, 1}, [57] = {1005, 1}, [58] = {1006, 1}, [59] = {1007, 1}, [60] = {1010, 1}, [61] = {1012, 1}, [62] = {1492, 1}, [63] = {1602, 2}, [64] = {1603, 2}, [65] = {1604, 2}, [66] = {1605, 2}, [67] = {1606, 2}, [68] = {1607, 2}, [69] = {1608, 2}, [70] = {1609, 2}, [71] = {1610, 2}, [72] = {1611, 2}, [73] = {1612, 2}, [74] = {1613, 2}, [75] = {1614, 2}, [76] = {1615, 2}, [77] = {1616, 2}, [78] = {1617, 2}, [79] = {1618, 2}, [80] = {1619, 2}, [81] = {1620, 2}, [82] = {1621, 2}, [83] = {1622, 2}, [84] = {1623, 2}, [85] = {1624, 2}, [86] = {1625, 2}, [87] = {1626, 2}, [88] = {1811, 1}},
[6] = { [1] = {62, 3}, [2] = {63, 3}, [3] = {64, 3}, [4] = {65, 3}, [5] = {66, 3}, [6] = {67, 3}, [7] = {68, 3}, [8] = {69, 3}, [9] = {70, 3}, [10] = {71, 3}, [11] = {72, 3}, [12] = {73, 3}, [13] = {74, 3}, [14] = {75, 3}, [15] = {76, 3}, [16] = {77, 3}, [17] = {78, 3}, [18] = {79, 3}, [19] = {80, 3}, [20] = {81, 3}, [21] = {82, 3}, [22] = {83, 3}, [23] = {84, 3}, [24] = {85, 3}, [25] = {86, 3}, [26] = {87, 3}, [27] = {88, 3}, [28] = {89, 3}, [29] = {90, 3}, [30] = {91, 3}, [31] = {92, 3}, [32] = {93, 3}, [33] = {94, 3}, [34] = {95, 3}, [35] = {96, 3}, [36] = {97, 3}, [37] = {98, 3}, [38] = {99, 3}, [39] = {100, 3}, [40] = {101, 3}, [41] = {102, 3}, [42] = {103, 3}, [43] = {104, 3}, [44] = {105, 3}, [45] = {106, 3}, [46] = {113, 3}, [47] = {114, 3}, [48] = {115, 3}, [49] = {116, 3}, [50] = {117, 3}, [51] = {118, 3}, [52] = {119, 3}, [53] = {120, 3}, [54] = {121, 3}, [55] = {122, 3}, [56] = {123, 3}, [57] = {124, 3}, [58] = {125, 3}, [59] = {126, 3}, [60] = {127, 3}, [61] = {128, 3}, [62] = {137, 3}, [63] = {138, 3}, [64] = {139, 3}, [65] = {140, 3}, [66] = {141, 3}, [67] = {142, 3}, [68] = {143, 3}, [69] = {144, 3}, [70] = {145, 3}, [71] = {146, 3}, [72] = {147, 3}, [73] = {148, 3}, [74] = {149, 3}, [75] = {150, 3}, [76] = {151, 3}, [77] = {152, 3}, [78] = {365, 3}, [79] = {366, 3}, [80] = {381, 3}, [81] = {382, 3}, [82] = {392, 3}, [83] = {400, 3}, [84] = {414, 3}, [85] = {428, 3}, [86] = {429, 3}, [87] = {459, 3}, [88] = {460, 3}, [89] = {462, 3}, [90] = {463, 3}, [91] = {465, 3}, [92] = {497, 3}, [93] = {498, 3}, [94] = {500, 3}, [95] = {501, 3}, [96] = {512, 3}, [97] = {559, 3}, [98] = {568, 3}, [99] = {569, 3}, [100] = {570, 3}},
[7] = { [1] = {67, 1}, [2] = {68, 1}, [3] = {69, 1}, [4] = {90, 1}, [5] = {91, 1}, [6] = {92, 1}, [7] = {93, 1}, [8] = {114, 1}, [9] = {115, 1}, [10] = {116, 1}, [11] = {117, 1}, [12] = {206, 1}, [13] = {209, 1}, [14] = {210, 1}, [15] = {267, 2}, [16] = {955, 1}, [17] = {956, 1}, [18] = {991, 1}, [19] = {997, 1}, [20] = {998, 1}, [21] = {999, 1}, [22] = {1000, 1}, [23] = {1001, 1}, [24] = {1002, 1}, [25] = {1123, 1}, [26] = {1124, 1}, [27] = {1125, 1}, [28] = {1210, 1}, [29] = {1610, 1}, [30] = {1611, 1}, [31] = {1663, 1}, [32] = {1664, 1}, [33] = {1677, 1}, [34] = {1678, 1}, [35] = {1680, 1}, [36] = {1681, 1}, [37] = {1794, 1}, [38] = {1796, 1}, [39] = {1797, 1}},
[8] = { [1] = {138, 2}, [2] = {139, 2}, [3] = {260, 2}, [4] = {261, 2}, [5] = {262, 2}, [6] = {263, 2}, [7] = {264, 2}, [8] = {265, 2}, [9] = {266, 2}, [10] = {267, 2}, [11] = {268, 2}, [12] = {269, 2}, [13] = {270, 2}, [14] = {271, 2}, [15] = {272, 2}, [16] = {273, 2}, [17] = {274, 2}, [18] = {275, 2}, [19] = {278, 2}, [20] = {282, 1}, [21] = {283, 1}, [22] = {284, 1}, [23] = {515, 3}, [24] = {548, 2}, [25] = {624, 2}, [26] = {625, 3}, [27] = {738, 2}, [28] = {746, 3}, [29] = {747, 2}, [30] = {748, 2}, [31] = {749, 3}, [32] = {750, 2}, [33] = {964, 3}, [34] = {965, 3}, [35] = {966, 3}, [36] = {967, 3}, [37] = {968, 3}, [38] = {982, 2}, [39] = {983, 2}, [40] = {984, 2}, [41] = {985, 2}, [42] = {1281, 3}, [43] = {1282, 3}, [44] = {1315, 2}, [45] = {1316, 2}, [46] = {1338, 2}, [47] = {1339, 2}, [48] = {1347, 3}, [49] = {1348, 3}, [50] = {1367, 3}, [51] = {1368, 3}, [52] = {1369, 3}, [53] = {1374, 3}, [54] = {1375, 3}, [55] = {1377, 3}, [56] = {1387, 2}, [57] = {1388, 2}, [58] = {1390, 3}, [59] = {1391, 3}, [60] = {1420, 3}, [61] = {1421, 3}, [62] = {1423, 3}, [63] = {1424, 3}, [64] = {1426, 3}, [65] = {1427, 3}, [66] = {1451, 3}, [67] = {1463, 3}, [68] = {1470, 3}, [69] = {1471, 3}, [70] = {1472, 3}, [71] = {1487, 3}, [72] = {1495, 3}, [73] = {1496, 3}, [74] = {1531, 2}, [75] = {1532, 2}, [76] = {1545, 3}, [77] = {1546, 3}, [78] = {1602, 2}, [79] = {1603, 2}, [80] = {1604, 2}, [81] = {1605, 2}, [82] = {1606, 2}, [83] = {1607, 2}, [84] = {1608, 2}, [85] = {1609, 2}, [86] = {1610, 2}, [87] = {1611, 2}, [88] = {1612, 3}, [89] = {1613, 3}, [90] = {1614, 3}, [91] = {1615, 2}, [92] = {1616, 2}, [93] = {1617, 2}, [94] = {1618, 2}, [95] = {1619, 2}, [96] = {1728, 3}, [97] = {1729, 3}, [98] = {1751, 3}, [99] = {1752, 3}, [100] = {1830, 3}, [101] = {1831, 3}, [102] = {1876, 3}, [103] = {1877, 3}, [104] = {1879, 3}, [105] = {1880, 3}, [106] = {1899, 3}, [107] = {1900, 3}, [108] = {1901, 3}, [109] = {1904, 3}, [110] = {1905, 3}, [111] = {1906, 3}, [112] = {1938, 2}, [113] = {1939, 2}, [114] = {1940, 2}, [115] = {1946, 3}, [116] = {1947, 3}, [117] = {1955, 3}, [118] = {1962, 2}, [119] = {1999, 2}, [120] = {2000, 2}, [121] = {2003, 2}, [122] = {2034, 2}, [123] = {2035, 2}, [124] = {2040, 3}, [125] = {2041, 3}, [126] = {2059, 2}, [127] = {2060, 2}, [128] = {2061, 2}, [129] = {2131, 3}, [130] = {2132, 3}, [131] = {2135, 2}, [132] = {2142, 3}, [133] = {2143, 3}},
[9] = { [1] = {136, 2}, [2] = {137, 2}, [3] = {138, 2}, [4] = {139, 2}, [5] = {140, 2}, [6] = {261, 2}, [7] = {262, 2}, [8] = {263, 2}, [9] = {264, 2}, [10] = {265, 2}, [11] = {266, 2}, [12] = {267, 2}, [13] = {268, 2}, [14] = {269, 2}, [15] = {270, 2}, [16] = {271, 2}, [17] = {272, 2}, [18] = {273, 2}, [19] = {274, 2}, [20] = {275, 2}, [21] = {276, 2}, [22] = {277, 2}, [23] = {278, 2}, [24] = {279, 2}, [25] = {280, 1}, [26] = {281, 1}, [27] = {282, 1}, [28] = {283, 2}, [29] = {284, 2}, [30] = {285, 2}, [31] = {1602, 2}, [32] = {1603, 2}, [33] = {1604, 2}, [34] = {1605, 2}, [35] = {1606, 2}, [36] = {1607, 2}, [37] = {1608, 2}, [38] = {1609, 3}, [39] = {1610, 3}, [40] = {1611, 3}, [41] = {1612, 3}, [42] = {1613, 3}, [43] = {1614, 3}, [44] = {1615, 3}, [45] = {1616, 3}, [46] = {1617, 3}, [47] = {1618, 3}, [48] = {1619, 3}, [49] = {1620, 2}, [50] = {1621, 2}, [51] = {1622, 2}, [52] = {1623, 2}, [53] = {1624, 2}, [54] = {1625, 2}, [55] = {1626, 2}},
[10] = { [1] = {136, 2}, [2] = {137, 2}, [3] = {138, 2}, [4] = {139, 2}, [5] = {140, 2}, [6] = {260, 1}, [7] = {261, 2}, [8] = {262, 2}, [9] = {263, 2}, [10] = {264, 2}, [11] = {265, 2}, [12] = {266, 2}, [13] = {267, 2}, [14] = {268, 2}, [15] = {269, 2}, [16] = {270, 2}, [17] = {271, 2}, [18] = {272, 2}, [19] = {273, 2}, [20] = {274, 2}, [21] = {275, 2}, [22] = {276, 2}, [23] = {277, 2}, [24] = {278, 2}, [25] = {279, 2}, [26] = {280, 2}, [27] = {281, 2}, [28] = {282, 2}, [29] = {283, 2}, [30] = {284, 2}, [31] = {285, 2}, [32] = {1207, 1}, [33] = {1209, 1}, [34] = {1211, 1}, [35] = {1602, 2}, [36] = {1603, 2}, [37] = {1604, 2}, [38] = {1605, 2}, [39] = {1606, 2}, [40] = {1607, 2}, [41] = {1608, 2}, [42] = {1609, 2}, [43] = {1610, 2}, [44] = {1611, 2}, [45] = {1612, 2}, [46] = {1613, 2}, [47] = {1614, 2}, [48] = {1615, 2}, [49] = {1616, 2}, [50] = {1617, 2}, [51] = {1618, 2}, [52] = {1619, 2}, [53] = {1620, 2}, [54] = {1621, 2}, [55] = {1622, 2}, [56] = {1623, 2}, [57] = {1624, 2}, [58] = {1625, 2}, [59] = {1626, 2}, [60] = {1768, 1}, [61] = {1769, 1}, [62] = {1777, 1}, [63] = {1778, 1}, [64] = {1779, 1}, [65] = {1780, 1}, [66] = {1908, 1}, [67] = {1909, 1}, [68] = {2088, 1}},
[11] = { [1] = {92, 1}, [2] = {93, 1}, [3] = {94, 1}, [4] = {95, 1}, [5] = {96, 1}, [6] = {117, 1}, [7] = {119, 1}, [8] = {120, 1}, [9] = {131, 1}, [10] = {132, 1}, [11] = {133, 1}, [12] = {134, 1}, [13] = {135, 1}, [14] = {136, 1}, [15] = {137, 1}, [16] = {138, 1}, [17] = {139, 1}, [18] = {140, 1}, [19] = {141, 1}, [20] = {142, 1}, [21] = {143, 1}, [22] = {144, 1}, [23] = {465, 1}, [24] = {466, 1}, [25] = {467, 1}, [26] = {468, 1}, [27] = {469, 1}, [28] = {470, 1}, [29] = {471, 1}, [30] = {472, 1}, [31] = {473, 1}, [32] = {474, 1}, [33] = {489, 1}, [34] = {490, 1}, [35] = {491, 1}, [36] = {492, 1}, [37] = {493, 1}, [38] = {631, 1}, [39] = {642, 1}, [40] = {809, 1}, [41] = {810, 1}, [42] = {977, 1}, [43] = {978, 1}, [44] = {1144, 2}, [45] = {1146, 1}, [46] = {1281, 1}, [47] = {1282, 1}, [48] = {1283, 1}, [49] = {1284, 1}, [50] = {1285, 1}, [51] = {1313, 1}, [52] = {1314, 1}, [53] = {1480, 2}, [54] = {1481, 2}, [55] = {1482, 2}, [56] = {1648, 2}, [57] = {1650, 1}, [58] = {1817, 1}, [59] = {1818, 1}},
[12] = { [1] = {136, 3}, [2] = {137, 3}, [3] = {138, 2}, [4] = {139, 2}, [5] = {140, 3}, [6] = {262, 2}, [7] = {263, 2}, [8] = {264, 2}, [9] = {265, 2}, [10] = {266, 2}, [11] = {267, 2}, [12] = {268, 2}, [13] = {269, 2}, [14] = {270, 2}, [15] = {271, 2}, [16] = {272, 2}, [17] = {273, 2}, [18] = {274, 2}, [19] = {275, 2}, [20] = {276, 2}, [21] = {277, 2}, [22] = {278, 2}, [23] = {280, 1}, [24] = {281, 1}, [25] = {282, 1}, [26] = {283, 1}, [27] = {284, 1}, [28] = {285, 1}, [29] = {988, 1}, [30] = {989, 1}, [31] = {990, 2}, [32] = {991, 1}, [33] = {992, 1}, [34] = {993, 1}, [35] = {994, 1}, [36] = {1602, 3}, [37] = {1603, 3}, [38] = {1604, 3}, [39] = {1605, 3}, [40] = {1606, 3}, [41] = {1607, 3}, [42] = {1608, 3}, [43] = {1609, 3}, [44] = {1610, 3}, [45] = {1611, 3}, [46] = {1612, 3}, [47] = {1613, 3}, [48] = {1614, 3}, [49] = {1615, 3}, [50] = {1616, 3}, [51] = {1617, 3}, [52] = {1618, 3}, [53] = {1619, 3}, [54] = {1620, 3}, [55] = {1621, 3}, [56] = {1622, 3}, [57] = {1623, 3}, [58] = {1624, 3}, [59] = {1625, 3}, [60] = {1626, 3}},
[13] = { [1] = {137, 1}, [2] = {138, 1}, [3] = {139, 1}, [4] = {140, 1}, [5] = {259, 2}, [6] = {260, 2}, [7] = {261, 2}, [8] = {262, 2}, [9] = {263, 2}, [10] = {264, 2}, [11] = {265, 2}, [12] = {266, 2}, [13] = {267, 2}, [14] = {268, 2}, [15] = {269, 2}, [16] = {270, 2}, [17] = {271, 2}, [18] = {272, 2}, [19] = {273, 2}, [20] = {274, 2}, [21] = {275, 2}, [22] = {276, 2}, [23] = {277, 2}, [24] = {278, 2}, [25] = {279, 2}, [26] = {280, 2}, [27] = {281, 2}, [28] = {282, 2}, [29] = {283, 2}, [30] = {284, 2}, [31] = {285, 2}, [32] = {705, 1}, [33] = {706, 2}, [34] = {707, 2}, [35] = {708, 2}, [36] = {1605, 2}, [37] = {1606, 2}, [38] = {1607, 2}, [39] = {1608, 2}, [40] = {1609, 2}, [41] = {1610, 2}, [42] = {1611, 2}, [43] = {1612, 2}, [44] = {1613, 2}, [45] = {1614, 2}, [46] = {1615, 2}, [47] = {1616, 2}, [48] = {1617, 2}, [49] = {1618, 2}, [50] = {1619, 2}, [51] = {1620, 2}, [52] = {1621, 2}, [53] = {1622, 2}, [54] = {1623, 2}, [55] = {1624, 2}, [56] = {1625, 2}, [57] = {1626, 2}, [58] = {1627, 2}, [59] = {1628, 2}, [60] = {1629, 2}, [61] = {1630, 2}, [62] = {1631, 2}, [63] = {1632, 2}, [64] = {1633, 2}, [65] = {1635, 2}, [66] = {1636, 1}, [67] = {1637, 2}, [68] = {1638, 2}, [69] = {1639, 2}},
[14] = { [1] = {136, 2}, [2] = {137, 2}, [3] = {138, 2}, [4] = {140, 2}, [5] = {209, 1}, [6] = {210, 1}, [7] = {211, 1}, [8] = {212, 1}, [9] = {213, 1}, [10] = {215, 1}, [11] = {217, 1}, [12] = {220, 1}, [13] = {221, 1}, [14] = {222, 1}, [15] = {267, 1}, [16] = {268, 1}, [17] = {269, 1}, [18] = {270, 1}, [19] = {271, 1}, [20] = {272, 1}, [21] = {273, 2}, [22] = {274, 1}, [23] = {275, 2}, [24] = {276, 2}, [25] = {277, 2}, [26] = {278, 1}, [27] = {987, 2}, [28] = {989, 2}, [29] = {990, 1}, [30] = {991, 1}, [31] = {992, 1}, [32] = {993, 1}, [33] = {994, 1}, [34] = {999, 2}, [35] = {1000, 2}, [36] = {1001, 2}, [37] = {1002, 2}, [38] = {1003, 1}, [39] = {1004, 2}, [40] = {1005, 2}, [41] = {1006, 1}, [42] = {1007, 1}, [43] = {1008, 1}, [44] = {1009, 1}, [45] = {1012, 1}, [46] = {1187, 2}, [47] = {1188, 1}, [48] = {1602, 2}, [49] = {1603, 2}, [50] = {1604, 2}, [51] = {1605, 2}, [52] = {1606, 2}, [53] = {1607, 2}, [54] = {1608, 2}, [55] = {1609, 3}, [56] = {1610, 3}, [57] = {1611, 3}, [58] = {1612, 3}, [59] = {1613, 3}, [60] = {1614, 3}, [61] = {1615, 3}, [62] = {1616, 3}, [63] = {1617, 3}, [64] = {1618, 3}, [65] = {1619, 3}, [66] = {1620, 3}, [67] = {1621, 3}, [68] = {1622, 3}, [69] = {1623, 3}, [70] = {1624, 2}, [71] = {1625, 2}, [72] = {1626, 2}},
[15] = { [1] = {204, 2}, [2] = {220, 2}, [3] = {221, 2}, [4] = {246, 2}, [5] = {250, 2}, [6] = {256, 2}, [7] = {396, 2}, [8] = {403, 2}, [9] = {440, 2}, [10] = {483, 2}, [11] = {500, 2}, [12] = {501, 2}, [13] = {695, 2}, [14] = {761, 2}, [15] = {798, 2}, [16] = {810, 2}, [17] = {987, 2}, [18] = {988, 2}, [19] = {989, 2}, [20] = {990, 2}, [21] = {991, 2}, [22] = {992, 1}, [23] = {998, 2}, [24] = {999, 2}, [25] = {1000, 2}, [26] = {1001, 1}, [27] = {1002, 2}, [28] = {1003, 2}, [29] = {1004, 1}, [30] = {1005, 2}, [31] = {1007, 2}, [32] = {1012, 2}, [33] = {1075, 2}, [34] = {1369, 2}, [35] = {1370, 2}, [36] = {1371, 2}, [37] = {1372, 2}, [38] = {1373, 2}, [39] = {1374, 2}, [40] = {1375, 2}, [41] = {1376, 2}, [42] = {1377, 2}, [43] = {1378, 2}, [44] = {1379, 2}, [45] = {1380, 2}, [46] = {1381, 2}, [47] = {1382, 2}, [48] = {1383, 2}, [49] = {1384, 2}, [50] = {1386, 2}, [51] = {1387, 1}, [52] = {1388, 1}, [53] = {1389, 2}, [54] = {1390, 2}, [55] = {1391, 1}, [56] = {1729, 1}, [57] = {1738, 1}, [58] = {1959, 1}},
[16] = { [1] = {136, 3}, [2] = {137, 3}, [3] = {138, 3}, [4] = {139, 2}, [5] = {140, 2}, [6] = {221, 1}, [7] = {222, 1}, [8] = {263, 1}, [9] = {264, 2}, [10] = {265, 2}, [11] = {266, 2}, [12] = {267, 2}, [13] = {268, 2}, [14] = {269, 2}, [15] = {270, 2}, [16] = {271, 2}, [17] = {272, 2}, [18] = {273, 2}, [19] = {274, 2}, [20] = {275, 2}, [21] = {276, 2}, [22] = {277, 2}, [23] = {278, 2}, [24] = {279, 1}, [25] = {882, 2}, [26] = {988, 1}, [27] = {989, 1}, [28] = {990, 1}, [29] = {991, 1}, [30] = {1000, 1}, [31] = {1001, 1}, [32] = {1002, 1}, [33] = {1003, 1}, [34] = {1004, 1}, [35] = {1005, 1}, [36] = {1006, 1}, [37] = {1602, 3}, [38] = {1603, 3}, [39] = {1604, 3}, [40] = {1605, 3}, [41] = {1606, 3}, [42] = {1607, 3}, [43] = {1608, 3}, [44] = {1609, 3}, [45] = {1610, 3}, [46] = {1611, 3}, [47] = {1612, 3}, [48] = {1613, 3}, [49] = {1614, 3}, [50] = {1615, 3}, [51] = {1616, 3}, [52] = {1617, 3}, [53] = {1618, 3}, [54] = {1619, 3}, [55] = {1620, 3}, [56] = {1621, 3}, [57] = {1622, 3}, [58] = {1623, 3}, [59] = {1624, 3}, [60] = {1625, 3}, [61] = {1626, 3}, [62] = {2034, 1}, [63] = {2035, 1}, [64] = {2036, 1}, [65] = {2037, 1}, [66] = {2038, 1}, [67] = {2039, 1}, [68] = {2040, 1}, [69] = {2041, 1}, [70] = {2048, 1}, [71] = {2049, 1}, [72] = {2050, 1}, [73] = {2051, 1}, [74] = {2052, 1}, [75] = {2053, 1}, [76] = {2054, 1}, [77] = {2055, 1}, [78] = {2056, 1}},
[17] = { [1] = {90, 2}, [2] = {91, 2}, [3] = {137, 2}, [4] = {138, 2}, [5] = {139, 2}, [6] = {140, 2}, [7] = {141, 2}, [8] = {142, 2}, [9] = {205, 2}, [10] = {259, 2}, [11] = {260, 2}, [12] = {261, 2}, [13] = {262, 2}, [14] = {263, 2}, [15] = {264, 2}, [16] = {265, 2}, [17] = {266, 2}, [18] = {267, 2}, [19] = {268, 2}, [20] = {274, 2}, [21] = {275, 2}, [22] = {276, 2}, [23] = {277, 2}, [24] = {278, 2}, [25] = {279, 2}, [26] = {280, 2}, [27] = {281, 2}, [28] = {282, 2}, [29] = {283, 2}, [30] = {284, 2}, [31] = {285, 2}, [32] = {286, 2}, [33] = {618, 2}, [34] = {706, 2}, [35] = {707, 2}, [36] = {708, 2}, [37] = {709, 2}, [38] = {867, 2}, [39] = {1176, 2}, [40] = {1177, 2}, [41] = {1602, 2}, [42] = {1603, 2}, [43] = {1604, 2}, [44] = {1605, 2}, [45] = {1606, 2}, [46] = {1607, 2}, [47] = {1608, 2}, [48] = {1609, 2}, [49] = {1610, 2}, [50] = {1611, 2}, [51] = {1612, 2}, [52] = {1618, 2}, [53] = {1619, 2}, [54] = {1620, 2}, [55] = {1621, 2}, [56] = {1622, 2}, [57] = {1623, 2}, [58] = {1624, 2}, [59] = {1625, 2}, [60] = {1626, 2}, [61] = {1627, 2}, [62] = {1628, 2}, [63] = {1630, 2}, [64] = {1631, 2}, [65] = {1632, 2}, [66] = {1633, 2}, [67] = {1634, 2}, [68] = {1724, 1}, [69] = {1728, 1}, [70] = {1729, 1}, [71] = {1730, 1}, [72] = {1731, 1}, [73] = {1737, 1}, [74] = {1738, 1}, [75] = {1739, 1}, [76] = {1740, 1}, [77] = {1741, 1}, [78] = {1742, 1}, [79] = {1743, 1}, [80] = {1884, 1}, [81] = {1885, 1}, [82] = {1886, 1}, [83] = {1887, 1}, [84] = {1888, 1}, [85] = {1891, 1}, [86] = {1892, 1}, [87] = {1893, 1}, [88] = {1894, 1}, [89] = {1895, 1}, [90] = {1896, 1}, [91] = {1897, 1}, [92] = {1942, 1}, [93] = {1943, 1}, [94] = {1945, 1}, [95] = {1946, 1}, [96] = {1947, 1}, [97] = {1948, 1}, [98] = {1964, 1}, [99] = {1965, 1}, [100] = {1966, 1}, [101] = {1967, 1}, [102] = {1968, 1}, [103] = {1969, 1}, [104] = {1970, 1}, [105] = {1971, 1}, [106] = {1972, 1}, [107] = {1973, 1}, [108] = {1974, 1}, [109] = {1987, 1}, [110] = {1988, 1}, [111] = {1989, 1}, [112] = {1990, 2}, [113] = {1991, 1}, [114] = {1992, 1}, [115] = {1993, 1}, [116] = {1994, 1}, [117] = {1995, 1}, [118] = {1996, 1}, [119] = {1997, 1}, [120] = {1998, 1}},
[18] = { [1] = {91, 2}, [2] = {138, 2}, [3] = {139, 2}, [4] = {140, 2}, [5] = {141, 2}, [6] = {142, 2}, [7] = {205, 2}, [8] = {260, 2}, [9] = {261, 2}, [10] = {262, 2}, [11] = {263, 2}, [12] = {264, 2}, [13] = {265, 2}, [14] = {266, 2}, [15] = {267, 2}, [16] = {268, 2}, [17] = {274, 2}, [18] = {275, 2}, [19] = {276, 2}, [20] = {277, 2}, [21] = {278, 2}, [22] = {279, 2}, [23] = {280, 2}, [24] = {281, 2}, [25] = {282, 2}, [26] = {283, 2}, [27] = {284, 2}, [28] = {285, 2}, [29] = {286, 2}, [30] = {706, 2}, [31] = {707, 2}, [32] = {708, 2}, [33] = {709, 2}, [34] = {867, 2}, [35] = {1602, 2}, [36] = {1603, 2}, [37] = {1604, 2}, [38] = {1605, 2}, [39] = {1606, 2}, [40] = {1607, 2}, [41] = {1608, 2}, [42] = {1609, 2}, [43] = {1610, 2}, [44] = {1611, 2}, [45] = {1612, 2}, [46] = {1618, 2}, [47] = {1619, 2}, [48] = {1620, 2}, [49] = {1621, 2}, [50] = {1622, 2}, [51] = {1624, 1}, [52] = {1625, 1}, [53] = {1626, 1}, [54] = {1627, 1}, [55] = {1628, 1}, [56] = {1629, 1}, [57] = {1630, 1}, [58] = {1631, 1}, [59] = {1632, 1}, [60] = {1633, 1}, [61] = {1634, 1}, [62] = {1724, 1}, [63] = {1729, 1}, [64] = {1730, 1}, [65] = {1731, 1}, [66] = {1737, 1}, [67] = {1738, 1}, [68] = {1739, 1}, [69] = {1740, 1}, [70] = {1741, 1}, [71] = {1742, 1}, [72] = {1743, 1}, [73] = {1884, 1}, [74] = {1885, 1}, [75] = {1886, 1}, [76] = {1887, 1}, [77] = {1888, 1}, [78] = {1890, 1}, [79] = {1891, 1}, [80] = {1892, 1}, [81] = {1893, 1}, [82] = {1894, 1}, [83] = {1895, 1}, [84] = {1896, 1}, [85] = {1943, 1}, [86] = {1944, 1}, [87] = {1945, 1}, [88] = {1946, 1}, [89] = {1947, 1}, [90] = {1948, 1}, [91] = {1964, 1}, [92] = {1965, 1}, [93] = {1966, 1}, [94] = {1967, 1}, [95] = {1968, 1}, [96] = {1969, 1}, [97] = {1970, 1}, [98] = {1971, 1}, [99] = {1972, 1}, [100] = {1973, 1}, [101] = {1974, 1}, [102] = {1987, 1}, [103] = {1988, 1}, [104] = {1989, 1}, [105] = {1990, 1}, [106] = {1991, 1}, [107] = {1992, 1}, [108] = {1993, 1}, [109] = {1994, 1}, [110] = {1995, 1}, [111] = {1996, 1}, [112] = {1997, 1}, [113] = {1998, 1}},
[19] = {},
[20] = {},
[21] = { [1] = {73, 1}, [2] = {733, 1}, [3] = {901, 1}},
[22] = { [1] = {80, 2}, [2] = {81, 2}, [3] = {82, 2}, [4] = {320, 2}, [5] = {1625, 2}, [6] = {1626, 2}, [7] = {1627, 2}, [8] = {1628, 2}, [9] = {1629, 2}, [10] = {1630, 2}, [11] = {1631, 2}, [12] = {1655, 2}, [13] = {1656, 3}, [14] = {1657, 3}, [15] = {1658, 3}, [16] = {1659, 3}, [17] = {1660, 2}, [18] = {1661, 2}, [19] = {1662, 2}, [20] = {1747, 2}, [21] = {1822, 2}, [22] = {1823, 2}, [23] = {1824, 2}, [24] = {1825, 2}, [25] = {1826, 3}, [26] = {1827, 3}, [27] = {1828, 3}, [28] = {1829, 3}, [29] = {1830, 2}, [30] = {1831, 2}, [31] = {1832, 2}, [32] = {1833, 2}, [33] = {1839, 1}, [34] = {1840, 2}, [35] = {1841, 2}, [36] = {1842, 2}, [37] = {1843, 2}, [38] = {1844, 2}, [39] = {1845, 2}, [40] = {1846, 2}, [41] = {1847, 2}, [42] = {1848, 2}, [43] = {1849, 2}, [44] = {1850, 2}, [45] = {1851, 2}, [46] = {1852, 2}, [47] = {1853, 2}, [48] = {1863, 1}, [49] = {1864, 1}, [50] = {1865, 2}, [51] = {1866, 2}, [52] = {1867, 2}, [53] = {1868, 2}, [54] = {1869, 1}, [55] = {1870, 1}, [56] = {1871, 1}, [57] = {1872, 1}, [58] = {1873, 1}, [59] = {1874, 2}, [60] = {1875, 2}, [61] = {1876, 2}, [62] = {1877, 2}, [63] = {1887, 1}, [64] = {1888, 1}, [65] = {1889, 2}, [66] = {1890, 2}, [67] = {1891, 2}, [68] = {1892, 2}, [69] = {1893, 1}, [70] = {1894, 1}, [71] = {1895, 1}, [72] = {1896, 2}, [73] = {1897, 2}, [74] = {1898, 2}, [75] = {1899, 2}, [76] = {1900, 2}, [77] = {1901, 2}, [78] = {1911, 1}, [79] = {1912, 1}, [80] = {1913, 2}, [81] = {1914, 2}, [82] = {1915, 2}, [83] = {1916, 2}, [84] = {1917, 2}, [85] = {1989, 1}, [86] = {1990, 1}, [87] = {1991, 1}, [88] = {1992, 1}, [89] = {1993, 1}, [90] = {1994, 1}, [91] = {1995, 1}, [92] = {2011, 1}, [93] = {2012, 1}, [94] = {2013, 1}, [95] = {2014, 1}, [96] = {2015, 1}, [97] = {2016, 1}, [98] = {2017, 1}, [99] = {2018, 1}, [100] = {2019, 1}, [101] = {2132, 2}, [102] = {2136, 2}, [103] = {2137, 2}, [104] = {2138, 2}, [105] = {2139, 2}, [106] = {2140, 2}, [107] = {2141, 2}, [108] = {2142, 2}, [109] = {2143, 2}, [110] = {2144, 2}, [111] = {2145, 2}, [112] = {2146, 2}, [113] = {2147, 2}, [114] = {2148, 2}, [115] = {2149, 2}, [116] = {2150, 2}, [117] = {2151, 2}, [118] = {2152, 2}, [119] = {2153, 2}, [120] = {2154, 2}, [121] = {2155, 2}, [122] = {2156, 2}, [123] = {2157, 2}, [124] = {2158, 2}}
}

local zz = 0

for line in io.lines(filePath) do
	local tokens = {}
	local index = 0
	for token in string.gmatch(line,"[_.%w]+") do
		index = index + 1
		tokens[index] = token
	end

	if(tokens[2] == "1h") then

		zz = zz + 1

		if(zz > 0) then

			local name = tokens[1]
			--print(name)

			local graph = {}
			local size = index/3 - 1

			for ii = 1,size do
				local triple = {}
				triple[1] = tonumber(tokens[3*ii + 1])
				triple[2] = tonumber(tokens[3*ii + 2])
				triple[3] = tonumber(tokens[3*ii + 3])
				graph[ii] = triple
			end

			local result = calculate_fdi(0, 3600, graph)

--[[
			for key,value in pairs(result) do
				print(key)
				print(value[1])
				print(value[2])
				print(value[3])
		  end
]]

			local tdind = 0
			for key,value in pairs(result) do
				if(value[2]) then
						local td = key - 1
						tdind = tdind + 1
						--print(matlab[1][1][1])
						--print(td)
						assert(matlab[zz][tdind][1] == td, string.format('failed test alarm: signal num = %d, alert num = %d, got %d instead of %d', zz, tdind, td, matlab[zz][tdind][1]))
						assert(matlab[zz][tdind][2] == value[3], string.format('failed test level: signal num = %d, alert num = %d, got %d instead of %d', zz, tdind, value[3], matlab[zz][tdind][2]))
				end
			end
			assert(tdind == table.getn(matlab[zz]), string.format('failed test: signal num = %d, entries num = %d, expected = %d',zz, tdind, table.getn(matlab[zz])))
		end
	end
end
