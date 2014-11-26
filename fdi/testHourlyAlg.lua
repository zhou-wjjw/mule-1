require 'calculate_fdi'

local filePath = './fdi/fixtures/graphs_of_interest.txt'
--local filePath = './fixtures/graphs_of_interest.txt'

local matlab = {
[1] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 3}, [4] = {195, 3}, [5] = {196, 3}, [6] = {317, 2}, [7] = {318, 2}, [8] = {319, 2}, [9] = {320, 2}, [10] = {321, 2}, [11] = {322, 2}, [12] = {323, 2}, [13] = {324, 2}, [14] = {325, 2}, [15] = {326, 2}, [16] = {327, 2}, [17] = {328, 2}, [18] = {329, 2}, [19] = {330, 2}, [20] = {331, 2}, [21] = {332, 2}, [22] = {333, 2}, [23] = {334, 2}, [24] = {335, 2}, [25] = {336, 2}, [26] = {337, 2}, [27] = {338, 1}, [28] = {339, 2}, [29] = {340, 2}, [30] = {341, 2}, [31] = {1658, 3}, [32] = {1659, 3}, [33] = {1660, 3}, [34] = {1661, 3}, [35] = {1662, 3}, [36] = {1663, 3}, [37] = {1664, 3}, [38] = {1665, 3}, [39] = {1666, 3}, [40] = {1667, 3}, [41] = {1668, 3}, [42] = {1669, 3}, [43] = {1670, 3}, [44] = {1671, 3}, [45] = {1672, 3}, [46] = {1673, 3}, [47] = {1674, 3}, [48] = {1675, 3}, [49] = {1676, 3}, [50] = {1677, 3}, [51] = {1678, 3}, [52] = {1679, 3}, [53] = {1680, 3}, [54] = {1681, 3}, [55] = {1682, 3}, [56] = {2150, 3}},
[2] = { [1] = {192, 2}, [2] = {193, 2}, [3] = {194, 2}, [4] = {195, 2}, [5] = {196, 2}, [6] = {264, 1}, [7] = {267, 1}, [8] = {268, 1}, [9] = {279, 2}, [10] = {316, 2}, [11] = {317, 2}, [12] = {318, 2}, [13] = {319, 1}, [14] = {320, 2}, [15] = {321, 2}, [16] = {322, 2}, [17] = {323, 2}, [18] = {324, 2}, [19] = {325, 2}, [20] = {326, 2}, [21] = {327, 2}, [22] = {328, 2}, [23] = {329, 2}, [24] = {330, 2}, [25] = {331, 2}, [26] = {332, 2}, [27] = {333, 2}, [28] = {334, 2}, [29] = {335, 2}, [30] = {336, 2}, [31] = {337, 2}, [32] = {339, 2}, [33] = {341, 2}, [34] = {637, 2}, [35] = {640, 1}, [36] = {1044, 1}, [37] = {1045, 1}, [38] = {1046, 1}, [39] = {1047, 1}, [40] = {1054, 1}, [41] = {1055, 1}, [42] = {1061, 1}, [43] = {1240, 1}, [44] = {1241, 1}, [45] = {1244, 1}, [46] = {1658, 2}, [47] = {1659, 2}, [48] = {1660, 2}, [49] = {1661, 2}, [50] = {1662, 2}, [51] = {1663, 2}, [52] = {1664, 2}, [53] = {1665, 2}, [54] = {1666, 2}, [55] = {1667, 2}, [56] = {1668, 2}, [57] = {1669, 2}, [58] = {1670, 2}, [59] = {1671, 2}, [60] = {1672, 2}, [61] = {1673, 2}, [62] = {1674, 2}, [63] = {1675, 2}, [64] = {1676, 2}, [65] = {1677, 2}, [66] = {1678, 2}, [67] = {1679, 2}, [68] = {1680, 2}, [69] = {1681, 2}, [70] = {1682, 2}, [71] = {1778, 1}, [72] = {1783, 1}, [73] = {1791, 1}, [74] = {1792, 1}, [75] = {1793, 1}, [76] = {1794, 1}, [77] = {1795, 1}, [78] = {1796, 1}, [79] = {1797, 1}},
[3] = { [1] = {120, 3}, [2] = {121, 3}, [3] = {135, 3}, [4] = {136, 3}, [5] = {137, 3}, [6] = {138, 3}, [7] = {159, 3}, [8] = {160, 3}, [9] = {172, 2}, [10] = {183, 3}, [11] = {184, 3}, [12] = {185, 3}, [13] = {186, 3}, [14] = {196, 2}, [15] = {207, 3}, [16] = {210, 3}, [17] = {264, 2}, [18] = {316, 2}, [19] = {328, 1}, [20] = {335, 1}, [21] = {530, 1}, [22] = {672, 2}, [23] = {674, 1}, [24] = {696, 2}, [25] = {941, 1}, [26] = {942, 1}, [27] = {1204, 2}, [28] = {1256, 1}, [29] = {1399, 2}, [30] = {1417, 2}, [31] = {1697, 2}, [32] = {1779, 1}, [33] = {1780, 1}, [34] = {1781, 1}, [35] = {1782, 1}, [36] = {1783, 1}, [37] = {1784, 1}, [38] = {1785, 1}, [39] = {1944, 1}, [40] = {1946, 1}, [41] = {1947, 1}, [42] = {1949, 1}, [43] = {1950, 1}, [44] = {1951, 1}, [45] = {1952, 1}, [46] = {1974, 2}, [47] = {2011, 2}, [48] = {2053, 1}, [49] = {2113, 1}, [50] = {2155, 2}, [51] = {2159, 2}, [52] = {2166, 2}, [53] = {2167, 2}, [54] = {2180, 2}, [55] = {2181, 2}, [56] = {2200, 2}},
[4] = { [1] = {146, 1}, [2] = {183, 2}, [3] = {184, 2}, [4] = {306, 2}, [5] = {308, 2}, [6] = {327, 2}, [7] = {328, 2}, [8] = {660, 2}, [9] = {736, 1}, [10] = {818, 1}, [11] = {885, 2}, [12] = {1011, 1}, [13] = {1058, 1}, [14] = {1059, 1}, [15] = {1065, 1}, [16] = {1082, 1}, [17] = {1137, 2}, [18] = {1160, 1}, [19] = {1161, 1}, [20] = {1330, 1}, [21] = {1331, 1}, [22] = {1381, 1}, [23] = {1382, 1}, [24] = {1396, 1}, [25] = {1617, 1}, [26] = {1622, 1}, [27] = {1672, 1}, [28] = {2011, 3}, [29] = {2195, 3}},
[5] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 3}, [4] = {195, 2}, [5] = {196, 2}, [6] = {261, 1}, [7] = {262, 2}, [8] = {264, 1}, [9] = {265, 1}, [10] = {266, 1}, [11] = {267, 1}, [12] = {268, 1}, [13] = {273, 1}, [14] = {275, 1}, [15] = {276, 1}, [16] = {277, 1}, [17] = {278, 1}, [18] = {279, 1}, [19] = {280, 1}, [20] = {285, 1}, [21] = {286, 1}, [22] = {287, 1}, [23] = {288, 1}, [24] = {289, 1}, [25] = {290, 1}, [26] = {291, 1}, [27] = {292, 1}, [28] = {294, 1}, [29] = {295, 1}, [30] = {296, 1}, [31] = {297, 1}, [32] = {298, 1}, [33] = {299, 1}, [34] = {300, 1}, [35] = {329, 2}, [36] = {330, 2}, [37] = {331, 2}, [38] = {332, 2}, [39] = {333, 2}, [40] = {334, 1}, [41] = {1043, 2}, [42] = {1044, 2}, [43] = {1045, 2}, [44] = {1046, 2}, [45] = {1047, 2}, [46] = {1048, 2}, [47] = {1050, 1}, [48] = {1053, 1}, [49] = {1054, 1}, [50] = {1055, 1}, [51] = {1056, 1}, [52] = {1057, 1}, [53] = {1058, 1}, [54] = {1060, 1}, [55] = {1061, 1}, [56] = {1062, 1}, [57] = {1063, 1}, [58] = {1065, 1}, [59] = {1066, 1}, [60] = {1068, 1}, [61] = {1069, 1}, [62] = {1548, 1}, [63] = {1658, 3}, [64] = {1659, 3}, [65] = {1660, 3}, [66] = {1661, 3}, [67] = {1662, 3}, [68] = {1663, 2}, [69] = {1664, 2}, [70] = {1665, 2}, [71] = {1666, 2}, [72] = {1667, 2}, [73] = {1668, 2}, [74] = {1669, 2}, [75] = {1670, 2}, [76] = {1671, 3}, [77] = {1672, 3}, [78] = {1673, 3}, [79] = {1674, 3}, [80] = {1675, 3}, [81] = {1676, 3}, [82] = {1677, 3}, [83] = {1678, 3}, [84] = {1679, 3}, [85] = {1680, 3}, [86] = {1681, 3}, [87] = {1682, 3}},
[6] = { [1] = {1683, 3}, [2] = {1684, 3}, [3] = {1685, 3}, [4] = {1686, 3}, [5] = {1687, 3}, [6] = {1688, 3}, [7] = {1689, 3}, [8] = {1690, 3}, [9] = {1691, 3}, [10] = {1692, 3}, [11] = {1693, 3}, [12] = {1694, 3}, [13] = {1695, 3}, [14] = {1696, 3}, [15] = {1697, 3}, [16] = {1698, 3}, [17] = {1699, 3}, [18] = {1700, 3}, [19] = {1701, 3}, [20] = {1702, 3}, [21] = {1703, 3}, [22] = {1704, 3}, [23] = {1705, 3}, [24] = {1706, 3}, [25] = {1707, 3}, [26] = {1708, 3}, [27] = {1709, 3}, [28] = {1710, 3}, [29] = {1711, 3}, [30] = {1712, 3}, [31] = {1713, 3}, [32] = {1714, 3}, [33] = {1715, 3}, [34] = {1716, 3}, [35] = {1717, 3}, [36] = {1718, 3}, [37] = {1719, 3}, [38] = {1720, 3}, [39] = {1721, 3}, [40] = {1722, 3}, [41] = {1723, 3}, [42] = {1724, 3}, [43] = {1725, 3}, [44] = {1726, 3}, [45] = {1727, 3}, [46] = {1734, 3}, [47] = {1735, 3}, [48] = {1736, 3}, [49] = {1737, 3}, [50] = {1738, 3}, [51] = {1739, 3}, [52] = {1740, 3}, [53] = {1741, 3}, [54] = {1742, 3}, [55] = {1743, 3}, [56] = {1744, 3}, [57] = {1745, 3}, [58] = {1746, 3}, [59] = {1747, 3}, [60] = {1748, 3}, [61] = {1749, 3}, [62] = {1758, 3}, [63] = {1759, 3}, [64] = {1760, 3}, [65] = {1761, 3}, [66] = {1762, 3}, [67] = {1763, 3}, [68] = {1764, 3}, [69] = {1765, 3}, [70] = {1766, 3}, [71] = {1767, 3}, [72] = {1768, 3}, [73] = {1769, 3}, [74] = {1770, 3}, [75] = {1771, 3}, [76] = {1772, 3}, [77] = {1773, 3}, [78] = {1986, 3}, [79] = {1987, 3}, [80] = {2002, 3}, [81] = {2003, 3}, [82] = {2013, 3}, [83] = {2021, 3}, [84] = {2035, 3}, [85] = {2049, 3}, [86] = {2050, 3}, [87] = {2080, 3}, [88] = {2081, 3}, [89] = {2083, 3}, [90] = {2084, 3}, [91] = {2086, 3}, [92] = {2118, 3}, [93] = {2119, 3}, [94] = {2121, 3}, [95] = {2122, 3}, [96] = {2133, 3}, [97] = {2180, 3}, [98] = {2189, 3}, [99] = {2190, 3}, [100] = {2191, 3}},
[7] = { [1] = {192, 2}, [2] = {193, 2}, [3] = {194, 2}, [4] = {195, 2}, [5] = {196, 2}, [6] = {262, 1}, [7] = {318, 2}, [8] = {319, 2}, [9] = {320, 2}, [10] = {321, 2}, [11] = {322, 2}, [12] = {323, 2}, [13] = {324, 2}, [14] = {325, 2}, [15] = {326, 2}, [16] = {327, 1}, [17] = {329, 1}, [18] = {333, 1}, [19] = {335, 1}, [20] = {426, 2}, [21] = {617, 2}, [22] = {1045, 1}, [23] = {1046, 1}, [24] = {1047, 2}, [25] = {1048, 1}, [26] = {1049, 1}, [27] = {1050, 1}, [28] = {1052, 1}, [29] = {1053, 1}, [30] = {1054, 1}, [31] = {1055, 1}, [32] = {1056, 1}, [33] = {1057, 1}, [34] = {1058, 1}, [35] = {1059, 1}, [36] = {1263, 1}, [37] = {1266, 1}, [38] = {1658, 3}, [39] = {1659, 3}, [40] = {1660, 3}, [41] = {1661, 3}, [42] = {1662, 3}, [43] = {1663, 3}, [44] = {1664, 3}, [45] = {1665, 3}, [46] = {1666, 3}, [47] = {1667, 3}, [48] = {1668, 3}, [49] = {1669, 3}, [50] = {1670, 3}, [51] = {1676, 2}, [52] = {1677, 2}, [53] = {1678, 2}, [54] = {1679, 2}, [55] = {1680, 2}, [56] = {1681, 2}, [57] = {1682, 2}, [58] = {1718, 1}, [59] = {1719, 1}, [60] = {1720, 1}, [61] = {1721, 1}, [62] = {1723, 1}, [63] = {1725, 1}, [64] = {1835, 1}, [65] = {1837, 1}, [66] = {1838, 1}, [67] = {1839, 1}, [68] = {1840, 1}, [69] = {1841, 1}, [70] = {1842, 1}, [71] = {1843, 1}, [72] = {1847, 1}},
[8] = { [1] = {195, 2}, [2] = {197, 1}, [3] = {317, 2}, [4] = {318, 2}, [5] = {319, 2}, [6] = {320, 2}, [7] = {321, 2}, [8] = {322, 2}, [9] = {323, 2}, [10] = {324, 2}, [11] = {325, 2}, [12] = {326, 2}, [13] = {327, 2}, [14] = {328, 2}, [15] = {329, 2}, [16] = {330, 2}, [17] = {331, 2}, [18] = {332, 2}, [19] = {333, 2}, [20] = {334, 2}, [21] = {335, 2}, [22] = {336, 1}, [23] = {337, 2}, [24] = {338, 1}, [25] = {339, 1}, [26] = {340, 1}, [27] = {341, 2}, [28] = {572, 3}, [29] = {605, 3}, [30] = {681, 3}, [31] = {682, 3}, [32] = {795, 2}, [33] = {803, 3}, [34] = {804, 2}, [35] = {805, 2}, [36] = {806, 3}, [37] = {807, 2}, [38] = {1021, 3}, [39] = {1022, 3}, [40] = {1023, 3}, [41] = {1024, 3}, [42] = {1025, 3}, [43] = {1039, 3}, [44] = {1040, 3}, [45] = {1041, 3}, [46] = {1042, 3}, [47] = {1338, 3}, [48] = {1339, 3}, [49] = {1372, 3}, [50] = {1373, 3}, [51] = {1395, 3}, [52] = {1396, 3}, [53] = {1404, 3}, [54] = {1405, 3}, [55] = {1424, 3}, [56] = {1425, 3}, [57] = {1426, 3}, [58] = {1431, 3}, [59] = {1432, 3}, [60] = {1434, 3}, [61] = {1444, 3}, [62] = {1445, 3}, [63] = {1447, 3}, [64] = {1448, 3}, [65] = {1477, 3}, [66] = {1478, 3}, [67] = {1480, 3}, [68] = {1481, 3}, [69] = {1483, 3}, [70] = {1484, 3}, [71] = {1508, 3}, [72] = {1520, 3}, [73] = {1527, 3}, [74] = {1528, 3}, [75] = {1529, 3}, [76] = {1544, 3}, [77] = {1552, 3}, [78] = {1553, 3}, [79] = {1588, 3}, [80] = {1589, 3}, [81] = {1602, 3}, [82] = {1603, 3}, [83] = {1659, 3}, [84] = {1660, 3}, [85] = {1661, 3}, [86] = {1662, 3}, [87] = {1663, 3}, [88] = {1664, 3}, [89] = {1665, 3}, [90] = {1666, 3}, [91] = {1667, 3}, [92] = {1668, 3}, [93] = {1669, 3}, [94] = {1670, 3}, [95] = {1671, 3}, [96] = {1672, 3}, [97] = {1673, 3}, [98] = {1674, 3}, [99] = {1675, 3}, [100] = {1676, 3}, [101] = {1785, 3}, [102] = {1786, 3}, [103] = {1808, 3}, [104] = {1809, 3}, [105] = {1887, 3}, [106] = {1888, 3}, [107] = {1933, 3}, [108] = {1934, 3}, [109] = {1936, 3}, [110] = {1937, 3}, [111] = {1956, 3}, [112] = {1957, 3}, [113] = {1958, 3}, [114] = {1961, 3}, [115] = {1962, 3}, [116] = {1963, 3}, [117] = {1995, 3}, [118] = {1996, 3}, [119] = {1997, 3}, [120] = {2003, 3}, [121] = {2004, 3}, [122] = {2012, 3}, [123] = {2019, 2}, [124] = {2056, 3}, [125] = {2057, 3}, [126] = {2060, 3}, [127] = {2091, 3}, [128] = {2092, 3}, [129] = {2097, 3}, [130] = {2098, 3}, [131] = {2116, 3}, [132] = {2117, 3}, [133] = {2118, 3}, [134] = {2188, 3}, [135] = {2189, 3}, [136] = {2199, 3}, [137] = {2200, 3}},
[9] = { [1] = {192, 2}, [2] = {193, 2}, [3] = {194, 2}, [4] = {195, 2}, [5] = {196, 2}, [6] = {317, 2}, [7] = {318, 2}, [8] = {319, 2}, [9] = {320, 2}, [10] = {321, 2}, [11] = {322, 2}, [12] = {323, 2}, [13] = {324, 2}, [14] = {325, 2}, [15] = {326, 2}, [16] = {327, 2}, [17] = {328, 2}, [18] = {329, 2}, [19] = {330, 2}, [20] = {331, 2}, [21] = {332, 2}, [22] = {333, 2}, [23] = {334, 2}, [24] = {335, 2}, [25] = {336, 1}, [26] = {337, 1}, [27] = {338, 1}, [28] = {339, 2}, [29] = {340, 2}, [30] = {341, 2}, [31] = {1658, 3}, [32] = {1659, 3}, [33] = {1660, 3}, [34] = {1661, 3}, [35] = {1662, 3}, [36] = {1663, 3}, [37] = {1664, 3}, [38] = {1665, 3}, [39] = {1666, 3}, [40] = {1667, 3}, [41] = {1668, 3}, [42] = {1669, 3}, [43] = {1670, 3}, [44] = {1671, 3}, [45] = {1672, 3}, [46] = {1673, 3}, [47] = {1674, 3}, [48] = {1675, 3}, [49] = {1676, 3}, [50] = {1677, 3}, [51] = {1678, 3}, [52] = {1679, 3}, [53] = {1680, 3}, [54] = {1681, 3}, [55] = {1682, 3}},
[10] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 3}, [4] = {195, 3}, [5] = {196, 3}, [6] = {315, 2}, [7] = {317, 2}, [8] = {318, 2}, [9] = {319, 2}, [10] = {320, 2}, [11] = {321, 2}, [12] = {322, 2}, [13] = {323, 2}, [14] = {324, 2}, [15] = {325, 2}, [16] = {326, 2}, [17] = {327, 2}, [18] = {328, 2}, [19] = {329, 2}, [20] = {330, 2}, [21] = {331, 2}, [22] = {332, 2}, [23] = {333, 2}, [24] = {334, 2}, [25] = {335, 2}, [26] = {336, 2}, [27] = {337, 2}, [28] = {338, 2}, [29] = {339, 2}, [30] = {340, 2}, [31] = {341, 2}, [32] = {1263, 1}, [33] = {1265, 1}, [34] = {1267, 1}, [35] = {1658, 2}, [36] = {1659, 2}, [37] = {1660, 2}, [38] = {1661, 2}, [39] = {1662, 2}, [40] = {1663, 2}, [41] = {1664, 3}, [42] = {1665, 3}, [43] = {1666, 3}, [44] = {1667, 3}, [45] = {1668, 3}, [46] = {1669, 3}, [47] = {1670, 3}, [48] = {1671, 3}, [49] = {1672, 3}, [50] = {1673, 2}, [51] = {1674, 2}, [52] = {1675, 2}, [53] = {1676, 2}, [54] = {1677, 2}, [55] = {1678, 3}, [56] = {1679, 2}, [57] = {1680, 2}, [58] = {1681, 2}, [59] = {1682, 2}, [60] = {1823, 2}, [61] = {1825, 1}, [62] = {1826, 1}, [63] = {1827, 1}, [64] = {1828, 1}, [65] = {1829, 1}, [66] = {1830, 1}, [67] = {1831, 1}, [68] = {1832, 1}, [69] = {1833, 1}, [70] = {1834, 1}, [71] = {1835, 1}, [72] = {1836, 1}, [73] = {1837, 1}, [74] = {1838, 1}, [75] = {1839, 1}, [76] = {1840, 1}, [77] = {1841, 1}, [78] = {1842, 1}, [79] = {1843, 1}, [80] = {1844, 1}, [81] = {1846, 1}, [82] = {1847, 1}, [83] = {1848, 1}, [84] = {1849, 1}, [85] = {1850, 1}, [86] = {1851, 1}, [87] = {1852, 1}, [88] = {1853, 1}, [89] = {1854, 1}, [90] = {1855, 1}, [91] = {1856, 1}, [92] = {1857, 1}, [93] = {1858, 1}, [94] = {1859, 1}, [95] = {1860, 1}, [96] = {1861, 1}, [97] = {1862, 1}, [98] = {1871, 1}, [99] = {1872, 1}, [100] = {1873, 1}, [101] = {1874, 1}, [102] = {1965, 1}, [103] = {2144, 1}},
[11] = { [1] = {478, 1}, [2] = {479, 1}, [3] = {480, 1}, [4] = {481, 1}, [5] = {482, 1}, [6] = {483, 1}, [7] = {484, 1}, [8] = {485, 1}, [9] = {1658, 3}, [10] = {1659, 3}, [11] = {1660, 3}, [12] = {1661, 3}, [13] = {1662, 3}, [14] = {1671, 3}, [15] = {1672, 3}, [16] = {1673, 3}, [17] = {1674, 3}, [18] = {1675, 3}, [19] = {1676, 3}, [20] = {1677, 3}, [21] = {1678, 3}, [22] = {1679, 3}, [23] = {1680, 3}, [24] = {1681, 3}, [25] = {1682, 3}},
[12] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 2}, [4] = {195, 2}, [5] = {196, 3}, [6] = {318, 2}, [7] = {319, 2}, [8] = {320, 2}, [9] = {321, 2}, [10] = {322, 2}, [11] = {323, 2}, [12] = {324, 2}, [13] = {325, 2}, [14] = {326, 2}, [15] = {327, 2}, [16] = {328, 2}, [17] = {329, 2}, [18] = {330, 2}, [19] = {331, 2}, [20] = {332, 2}, [21] = {333, 2}, [22] = {334, 2}, [23] = {1044, 1}, [24] = {1045, 1}, [25] = {1046, 1}, [26] = {1047, 1}, [27] = {1048, 1}, [28] = {1050, 1}, [29] = {1053, 1}, [30] = {1056, 1}, [31] = {1061, 1}, [32] = {1658, 3}, [33] = {1659, 3}, [34] = {1660, 3}, [35] = {1661, 3}, [36] = {1662, 3}, [37] = {1663, 3}, [38] = {1664, 3}, [39] = {1665, 3}, [40] = {1666, 3}, [41] = {1667, 3}, [42] = {1668, 3}, [43] = {1669, 3}, [44] = {1670, 3}, [45] = {1671, 3}, [46] = {1672, 3}, [47] = {1673, 3}, [48] = {1674, 3}, [49] = {1675, 3}, [50] = {1676, 3}, [51] = {1677, 3}, [52] = {1678, 3}, [53] = {1679, 3}, [54] = {1680, 3}, [55] = {1681, 3}, [56] = {1682, 3}},
[13] = { [1] = {192, 2}, [2] = {193, 2}, [3] = {194, 2}, [4] = {195, 2}, [5] = {196, 2}, [6] = {315, 3}, [7] = {316, 3}, [8] = {317, 3}, [9] = {318, 3}, [10] = {319, 3}, [11] = {320, 3}, [12] = {321, 3}, [13] = {322, 3}, [14] = {323, 3}, [15] = {324, 3}, [16] = {325, 3}, [17] = {326, 3}, [18] = {327, 3}, [19] = {328, 3}, [20] = {329, 3}, [21] = {330, 3}, [22] = {331, 3}, [23] = {332, 3}, [24] = {333, 3}, [25] = {334, 3}, [26] = {335, 3}, [27] = {336, 3}, [28] = {337, 3}, [29] = {338, 3}, [30] = {339, 3}, [31] = {340, 3}, [32] = {341, 3}, [33] = {761, 1}, [34] = {762, 2}, [35] = {763, 2}, [36] = {764, 2}, [37] = {1660, 2}, [38] = {1661, 2}, [39] = {1662, 2}, [40] = {1663, 3}, [41] = {1664, 3}, [42] = {1665, 3}, [43] = {1666, 3}, [44] = {1667, 3}, [45] = {1668, 3}, [46] = {1669, 3}, [47] = {1670, 3}, [48] = {1671, 3}, [49] = {1672, 3}, [50] = {1673, 3}, [51] = {1674, 3}, [52] = {1675, 3}, [53] = {1676, 3}, [54] = {1677, 3}, [55] = {1678, 3}, [56] = {1679, 2}, [57] = {1680, 2}, [58] = {1681, 2}, [59] = {1682, 2}, [60] = {1683, 2}, [61] = {1684, 2}, [62] = {1685, 2}, [63] = {1686, 2}, [64] = {1687, 2}, [65] = {1688, 2}, [66] = {1691, 2}, [67] = {1692, 2}, [68] = {1693, 2}, [69] = {1694, 2}, [70] = {1695, 2}},
[14] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 3}, [4] = {195, 2}, [5] = {196, 2}, [6] = {265, 1}, [7] = {266, 1}, [8] = {267, 1}, [9] = {268, 1}, [10] = {269, 1}, [11] = {272, 1}, [12] = {273, 1}, [13] = {276, 1}, [14] = {277, 1}, [15] = {278, 1}, [16] = {323, 1}, [17] = {324, 1}, [18] = {325, 1}, [19] = {326, 1}, [20] = {327, 1}, [21] = {328, 1}, [22] = {329, 2}, [23] = {330, 1}, [24] = {331, 2}, [25] = {332, 2}, [26] = {333, 2}, [27] = {334, 1}, [28] = {1043, 2}, [29] = {1045, 2}, [30] = {1046, 1}, [31] = {1047, 1}, [32] = {1048, 1}, [33] = {1049, 1}, [34] = {1050, 1}, [35] = {1055, 2}, [36] = {1056, 2}, [37] = {1057, 2}, [38] = {1058, 2}, [39] = {1059, 1}, [40] = {1060, 2}, [41] = {1061, 2}, [42] = {1062, 1}, [43] = {1063, 1}, [44] = {1064, 1}, [45] = {1065, 1}, [46] = {1068, 1}, [47] = {1243, 2}, [48] = {1244, 1}, [49] = {1658, 3}, [50] = {1659, 3}, [51] = {1660, 3}, [52] = {1661, 3}, [53] = {1662, 3}, [54] = {1663, 3}, [55] = {1664, 3}, [56] = {1665, 3}, [57] = {1666, 3}, [58] = {1667, 3}, [59] = {1668, 3}, [60] = {1669, 3}, [61] = {1670, 3}, [62] = {1671, 3}, [63] = {1672, 3}, [64] = {1673, 3}, [65] = {1674, 3}, [66] = {1675, 3}, [67] = {1676, 3}, [68] = {1677, 3}, [69] = {1678, 3}, [70] = {1679, 3}, [71] = {1680, 3}, [72] = {1681, 3}, [73] = {1682, 3}},
[15] = { [1] = {146, 2}, [2] = {159, 1}, [3] = {162, 1}, [4] = {168, 1}, [5] = {172, 1}, [6] = {216, 1}, [7] = {260, 2}, [8] = {261, 1}, [9] = {264, 1}, [10] = {267, 1}, [11] = {276, 2}, [12] = {277, 2}, [13] = {278, 1}, [14] = {279, 1}, [15] = {281, 1}, [16] = {282, 1}, [17] = {283, 1}, [18] = {295, 1}, [19] = {296, 2}, [20] = {302, 2}, [21] = {306, 2}, [22] = {312, 2}, [23] = {315, 1}, [24] = {316, 2}, [25] = {339, 2}, [26] = {341, 2}, [27] = {347, 1}, [28] = {350, 2}, [29] = {351, 1}, [30] = {353, 1}, [31] = {354, 1}, [32] = {428, 1}, [33] = {429, 1}, [34] = {435, 1}, [35] = {436, 2}, [36] = {438, 1}, [37] = {441, 1}, [38] = {443, 1}, [39] = {444, 1}, [40] = {445, 1}, [41] = {446, 1}, [42] = {447, 1}, [43] = {448, 1}, [44] = {450, 1}, [45] = {452, 2}, [46] = {453, 1}, [47] = {454, 1}, [48] = {455, 1}, [49] = {456, 1}, [50] = {458, 1}, [51] = {459, 2}, [52] = {496, 2}, [53] = {497, 1}, [54] = {517, 1}, [55] = {537, 1}, [56] = {539, 2}, [57] = {540, 1}, [58] = {541, 1}, [59] = {542, 1}, [60] = {543, 1}, [61] = {544, 1}, [62] = {556, 2}, [63] = {557, 2}, [64] = {559, 1}, [65] = {565, 1}, [66] = {605, 2}, [67] = {611, 2}, [68] = {620, 1}, [69] = {622, 1}, [70] = {673, 2}, [71] = {707, 1}, [72] = {712, 1}, [73] = {713, 1}, [74] = {751, 2}, [75] = {788, 1}, [76] = {817, 2}, [77] = {840, 1}, [78] = {842, 1}, [79] = {845, 1}, [80] = {848, 1}, [81] = {849, 1}, [82] = {854, 2}, [83] = {866, 2}, [84] = {872, 1}, [85] = {873, 1}, [86] = {874, 1}, [87] = {875, 1}, [88] = {876, 1}, [89] = {877, 1}, [90] = {878, 1}, [91] = {880, 1}, [92] = {881, 1}, [93] = {887, 1}, [94] = {888, 1}, [95] = {889, 2}, [96] = {890, 1}, [97] = {891, 1}, [98] = {892, 1}, [99] = {893, 1}, [100] = {894, 1}, [101] = {895, 1}, [102] = {896, 1}, [103] = {897, 1}, [104] = {898, 1}, [105] = {899, 2}, [106] = {900, 1}, [107] = {901, 1}, [108] = {902, 1}, [109] = {904, 1}, [110] = {907, 1}, [111] = {912, 1}, [112] = {948, 1}, [113] = {955, 1}, [114] = {970, 1}, [115] = {972, 1}, [116] = {1043, 2}, [117] = {1046, 1}, [118] = {1047, 1}, [119] = {1048, 1}, [120] = {1052, 1}, [121] = {1054, 1}, [122] = {1055, 1}, [123] = {1061, 2}, [124] = {1361, 2}, [125] = {1426, 1}, [126] = {1427, 2}, [127] = {1428, 2}, [128] = {1429, 2}, [129] = {1430, 2}, [130] = {1431, 2}, [131] = {1432, 2}, [132] = {1433, 2}, [133] = {1434, 2}, [134] = {1435, 2}, [135] = {1436, 2}, [136] = {1437, 2}, [137] = {1438, 2}, [138] = {1439, 2}, [139] = {1445, 2}, [140] = {1794, 2}, [141] = {1820, 1}, [142] = {1891, 2}, [143] = {1893, 2}, [144] = {1915, 2}, [145] = {1949, 1}},
[16] = { [1] = {192, 3}, [2] = {193, 3}, [3] = {194, 3}, [4] = {195, 2}, [5] = {196, 2}, [6] = {277, 1}, [7] = {278, 1}, [8] = {319, 1}, [9] = {320, 2}, [10] = {321, 2}, [11] = {322, 2}, [12] = {323, 2}, [13] = {324, 2}, [14] = {325, 2}, [15] = {326, 2}, [16] = {327, 2}, [17] = {328, 2}, [18] = {329, 2}, [19] = {330, 2}, [20] = {331, 2}, [21] = {332, 2}, [22] = {333, 2}, [23] = {334, 2}, [24] = {335, 1}, [25] = {938, 2}, [26] = {1044, 1}, [27] = {1045, 1}, [28] = {1046, 1}, [29] = {1047, 1}, [30] = {1056, 1}, [31] = {1057, 1}, [32] = {1058, 1}, [33] = {1059, 1}, [34] = {1060, 1}, [35] = {1061, 1}, [36] = {1062, 1}, [37] = {1658, 3}, [38] = {1659, 3}, [39] = {1660, 3}, [40] = {1661, 3}, [41] = {1662, 3}, [42] = {1663, 3}, [43] = {1664, 3}, [44] = {1665, 3}, [45] = {1666, 3}, [46] = {1667, 3}, [47] = {1668, 3}, [48] = {1669, 3}, [49] = {1670, 3}, [50] = {1671, 3}, [51] = {1672, 3}, [52] = {1673, 3}, [53] = {1674, 3}, [54] = {1675, 3}, [55] = {1676, 3}, [56] = {1677, 3}, [57] = {1678, 3}, [58] = {1679, 3}, [59] = {1680, 3}, [60] = {1681, 3}, [61] = {1682, 3}, [62] = {2090, 1}, [63] = {2091, 1}, [64] = {2092, 1}, [65] = {2093, 1}, [66] = {2094, 1}, [67] = {2095, 1}, [68] = {2096, 1}, [69] = {2097, 1}, [70] = {2104, 1}, [71] = {2105, 1}, [72] = {2106, 1}, [73] = {2107, 1}, [74] = {2108, 1}, [75] = {2109, 1}, [76] = {2110, 1}, [77] = {2111, 1}, [78] = {2112, 1}},
[17] = { [1] = {145, 2}, [2] = {146, 2}, [3] = {192, 3}, [4] = {193, 3}, [5] = {194, 3}, [6] = {195, 3}, [7] = {196, 3}, [8] = {197, 3}, [9] = {260, 3}, [10] = {314, 3}, [11] = {315, 3}, [12] = {316, 3}, [13] = {317, 3}, [14] = {318, 3}, [15] = {319, 3}, [16] = {320, 3}, [17] = {321, 3}, [18] = {322, 3}, [19] = {323, 3}, [20] = {324, 3}, [21] = {325, 3}, [22] = {326, 3}, [23] = {327, 3}, [24] = {328, 3}, [25] = {329, 3}, [26] = {330, 3}, [27] = {331, 3}, [28] = {332, 3}, [29] = {333, 3}, [30] = {334, 3}, [31] = {335, 3}, [32] = {336, 3}, [33] = {337, 3}, [34] = {338, 3}, [35] = {339, 3}, [36] = {340, 3}, [37] = {341, 3}, [38] = {540, 3}, [39] = {673, 2}, [40] = {760, 2}, [41] = {761, 3}, [42] = {762, 3}, [43] = {763, 3}, [44] = {764, 3}, [45] = {922, 2}, [46] = {1231, 3}, [47] = {1232, 3}, [48] = {1657, 3}, [49] = {1658, 3}, [50] = {1659, 3}, [51] = {1660, 3}, [52] = {1661, 3}, [53] = {1662, 3}, [54] = {1663, 3}, [55] = {1664, 3}, [56] = {1665, 3}, [57] = {1666, 3}, [58] = {1667, 3}, [59] = {1668, 3}, [60] = {1669, 3}, [61] = {1670, 3}, [62] = {1671, 3}, [63] = {1672, 3}, [64] = {1673, 3}, [65] = {1674, 3}, [66] = {1675, 3}, [67] = {1676, 3}, [68] = {1677, 3}, [69] = {1678, 3}, [70] = {1679, 3}, [71] = {1680, 3}, [72] = {1681, 3}, [73] = {1682, 3}, [74] = {1683, 3}, [75] = {1684, 2}, [76] = {1685, 2}, [77] = {1686, 2}, [78] = {1687, 2}, [79] = {1688, 2}, [80] = {1689, 2}, [81] = {1693, 2}, [82] = {1694, 2}, [83] = {1695, 2}, [84] = {1779, 1}, [85] = {1783, 1}, [86] = {1784, 1}, [87] = {1785, 1}, [88] = {1786, 1}, [89] = {1792, 1}, [90] = {1793, 1}, [91] = {1794, 1}, [92] = {1795, 1}, [93] = {1796, 1}, [94] = {1797, 1}, [95] = {1798, 1}, [96] = {1939, 1}, [97] = {1940, 1}, [98] = {1941, 1}, [99] = {1942, 1}, [100] = {1943, 1}, [101] = {1946, 1}, [102] = {1947, 1}, [103] = {1948, 1}, [104] = {1949, 1}, [105] = {1950, 1}, [106] = {1951, 1}, [107] = {1952, 1}, [108] = {1997, 1}, [109] = {1998, 1}, [110] = {2000, 1}, [111] = {2001, 1}, [112] = {2002, 1}, [113] = {2003, 1}, [114] = {2019, 1}, [115] = {2020, 1}, [116] = {2021, 1}, [117] = {2022, 1}, [118] = {2023, 1}, [119] = {2024, 1}, [120] = {2025, 1}, [121] = {2026, 1}, [122] = {2027, 1}, [123] = {2028, 1}, [124] = {2029, 1}, [125] = {2042, 1}, [126] = {2043, 1}, [127] = {2044, 1}, [128] = {2045, 1}, [129] = {2046, 1}, [130] = {2047, 1}, [131] = {2048, 1}, [132] = {2049, 1}, [133] = {2050, 1}, [134] = {2051, 1}, [135] = {2052, 1}, [136] = {2053, 1}},
[18] = { [1] = {145, 2}, [2] = {146, 2}, [3] = {192, 3}, [4] = {193, 3}, [5] = {194, 3}, [6] = {195, 3}, [7] = {196, 3}, [8] = {197, 3}, [9] = {260, 3}, [10] = {314, 3}, [11] = {315, 3}, [12] = {316, 3}, [13] = {317, 3}, [14] = {318, 3}, [15] = {319, 3}, [16] = {320, 3}, [17] = {321, 3}, [18] = {322, 3}, [19] = {323, 3}, [20] = {324, 3}, [21] = {325, 3}, [22] = {326, 3}, [23] = {327, 3}, [24] = {328, 3}, [25] = {329, 3}, [26] = {330, 3}, [27] = {331, 3}, [28] = {332, 3}, [29] = {333, 3}, [30] = {334, 3}, [31] = {335, 3}, [32] = {336, 3}, [33] = {337, 3}, [34] = {338, 3}, [35] = {339, 3}, [36] = {340, 3}, [37] = {341, 3}, [38] = {540, 3}, [39] = {673, 2}, [40] = {760, 2}, [41] = {761, 3}, [42] = {762, 3}, [43] = {763, 3}, [44] = {764, 3}, [45] = {922, 2}, [46] = {1657, 3}, [47] = {1658, 3}, [48] = {1659, 3}, [49] = {1660, 3}, [50] = {1661, 3}, [51] = {1662, 3}, [52] = {1663, 3}, [53] = {1664, 3}, [54] = {1665, 3}, [55] = {1666, 3}, [56] = {1667, 3}, [57] = {1668, 3}, [58] = {1669, 3}, [59] = {1670, 3}, [60] = {1671, 3}, [61] = {1672, 3}, [62] = {1673, 3}, [63] = {1674, 3}, [64] = {1675, 3}, [65] = {1676, 3}, [66] = {1677, 3}, [67] = {1678, 3}, [68] = {1679, 3}, [69] = {1680, 3}, [70] = {1681, 3}, [71] = {1682, 3}, [72] = {1683, 3}, [73] = {1684, 2}, [74] = {1685, 2}, [75] = {1686, 2}, [76] = {1687, 2}, [77] = {1688, 2}, [78] = {1689, 2}, [79] = {1693, 2}, [80] = {1694, 2}, [81] = {1695, 2}, [82] = {1779, 1}, [83] = {1783, 1}, [84] = {1784, 1}, [85] = {1785, 1}, [86] = {1786, 1}, [87] = {1792, 1}, [88] = {1793, 1}, [89] = {1794, 1}, [90] = {1795, 1}, [91] = {1796, 1}, [92] = {1797, 1}, [93] = {1798, 1}, [94] = {1939, 1}, [95] = {1940, 1}, [96] = {1941, 1}, [97] = {1942, 1}, [98] = {1943, 1}, [99] = {1945, 1}, [100] = {1946, 1}, [101] = {1947, 1}, [102] = {1949, 1}, [103] = {1950, 1}, [104] = {1951, 1}, [105] = {1952, 1}, [106] = {1997, 1}, [107] = {1998, 1}, [108] = {2000, 1}, [109] = {2001, 1}, [110] = {2002, 1}, [111] = {2003, 1}, [112] = {2018, 1}, [113] = {2019, 1}, [114] = {2021, 1}, [115] = {2022, 1}, [116] = {2023, 1}, [117] = {2024, 1}, [118] = {2025, 1}, [119] = {2026, 1}, [120] = {2027, 1}, [121] = {2028, 1}, [122] = {2029, 1}, [123] = {2042, 1}, [124] = {2043, 1}, [125] = {2044, 1}, [126] = {2045, 1}, [127] = {2046, 1}, [128] = {2047, 1}, [129] = {2048, 1}, [130] = {2049, 1}, [131] = {2050, 1}, [132] = {2051, 1}, [133] = {2052, 1}, [134] = {2053, 1}},
[19] = {},
[20] = { [1] = {194, 1}, [2] = {325, 2}, [3] = {326, 2}, [4] = {327, 2}, [5] = {328, 2}, [6] = {329, 2}, [7] = {330, 2}, [8] = {331, 2}, [9] = {332, 2}, [10] = {333, 2}, [11] = {334, 2}, [12] = {335, 2}, [13] = {336, 2}, [14] = {337, 2}, [15] = {338, 2}, [16] = {1056, 2}, [17] = {1359, 2}, [18] = {1460, 2}, [19] = {1461, 2}, [20] = {1502, 1}, [21] = {1503, 1}, [22] = {1504, 2}, [23] = {1508, 1}, [24] = {1659, 1}, [25] = {1670, 2}, [26] = {1671, 2}, [27] = {1672, 2}, [28] = {1673, 2}, [29] = {1674, 2}, [30] = {1675, 2}, [31] = {1676, 2}, [32] = {1677, 2}, [33] = {1678, 1}, [34] = {1679, 1}, [35] = {1680, 1}, [36] = {1681, 1}, [37] = {1682, 1}, [38] = {1683, 1}}
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
						local td = (value[1] - 1357344000 - 60 * 7 * 86400) / 3600
						tdind = tdind + 1
						assert(matlab[zz][tdind][1] == td, string.format('failed test alarm: signal num = %d, alert num = %d, got %d instead of %d', zz, tdind, td, matlab[zz][tdind][1]))
						assert(matlab[zz][tdind][2] == value[3], string.format('failed test level: signal num = %d, alert num = %d, got %d instead of %d', zz, tdind, value[3], matlab[zz][tdind][2]))
				end
			end


		end
	end
end





