######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Jeff Hodges - port to Ruby
#   Mark Pilgrim - port to Python
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

module Ladb::OpenCutList::CharDet
  HZ_cls = [
    1,0,0,0,0,0,0,0,  # 00 - 07 
    0,0,0,0,0,0,0,0,  # 08 - 0f 
    0,0,0,0,0,0,0,0,  # 10 - 17 
    0,0,0,1,0,0,0,0,  # 18 - 1f 
    0,0,0,0,0,0,0,0,  # 20 - 27 
    0,0,0,0,0,0,0,0,  # 28 - 2f 
    0,0,0,0,0,0,0,0,  # 30 - 37 
    0,0,0,0,0,0,0,0,  # 38 - 3f 
    0,0,0,0,0,0,0,0,  # 40 - 47 
    0,0,0,0,0,0,0,0,  # 48 - 4f 
    0,0,0,0,0,0,0,0,  # 50 - 57 
    0,0,0,0,0,0,0,0,  # 58 - 5f 
    0,0,0,0,0,0,0,0,  # 60 - 67 
    0,0,0,0,0,0,0,0,  # 68 - 6f 
    0,0,0,0,0,0,0,0,  # 70 - 77 
    0,0,0,4,0,5,2,0,  # 78 - 7f 
    1,1,1,1,1,1,1,1,  # 80 - 87 
    1,1,1,1,1,1,1,1,  # 88 - 8f 
    1,1,1,1,1,1,1,1,  # 90 - 97 
    1,1,1,1,1,1,1,1,  # 98 - 9f 
    1,1,1,1,1,1,1,1,  # a0 - a7 
    1,1,1,1,1,1,1,1,  # a8 - af 
    1,1,1,1,1,1,1,1,  # b0 - b7 
    1,1,1,1,1,1,1,1,  # b8 - bf 
    1,1,1,1,1,1,1,1,  # c0 - c7 
    1,1,1,1,1,1,1,1,  # c8 - cf 
    1,1,1,1,1,1,1,1,  # d0 - d7 
    1,1,1,1,1,1,1,1,  # d8 - df 
    1,1,1,1,1,1,1,1,  # e0 - e7 
    1,1,1,1,1,1,1,1,  # e8 - ef 
    1,1,1,1,1,1,1,1,  # f0 - f7 
    1,1,1,1,1,1,1,1,  # f8 - ff 
  ].freeze

  HZ_st = [
    EStart,EError,     3,EStart,EStart,EStart,EError,EError,# 00-07 
    EError,EError,EError,EError,EItsMe,EItsMe,EItsMe,EItsMe,# 08-0f 
    EItsMe,EItsMe,EError,EError,EStart,EStart,     4,EError,# 10-17 
    5,EError,     6,EError,     5,     5,     4,EError,# 18-1f 
    4,EError,     4,     4,     4,EError,     4,EError,# 20-27 
    4,EItsMe,EStart,EStart,EStart,EStart,EStart,EStart,# 28-2f 
  ].freeze

  HZCharLenTable = [0, 0, 0, 0, 0, 0].freeze

  HZSMModel = {'classTable' => HZ_cls,
    'classFactor' => 6,
    'stateTable' => HZ_st,
    'charLenTable' => HZCharLenTable,
    'name' => "HZ-GB-2312"
  }.freeze

ISO2022CN_cls = [
2,0,0,0,0,0,0,0,  # 00 - 07 
0,0,0,0,0,0,0,0,  # 08 - 0f 
0,0,0,0,0,0,0,0,  # 10 - 17 
0,0,0,1,0,0,0,0,  # 18 - 1f 
0,0,0,0,0,0,0,0,  # 20 - 27 
0,3,0,0,0,0,0,0,  # 28 - 2f 
0,0,0,0,0,0,0,0,  # 30 - 37 
0,0,0,0,0,0,0,0,  # 38 - 3f 
0,0,0,4,0,0,0,0,  # 40 - 47 
0,0,0,0,0,0,0,0,  # 48 - 4f 
0,0,0,0,0,0,0,0,  # 50 - 57 
0,0,0,0,0,0,0,0,  # 58 - 5f 
0,0,0,0,0,0,0,0,  # 60 - 67 
0,0,0,0,0,0,0,0,  # 68 - 6f 
0,0,0,0,0,0,0,0,  # 70 - 77 
0,0,0,0,0,0,0,0,  # 78 - 7f 
2,2,2,2,2,2,2,2,  # 80 - 87 
2,2,2,2,2,2,2,2,  # 88 - 8f 
2,2,2,2,2,2,2,2,  # 90 - 97 
2,2,2,2,2,2,2,2,  # 98 - 9f 
2,2,2,2,2,2,2,2,  # a0 - a7 
2,2,2,2,2,2,2,2,  # a8 - af 
2,2,2,2,2,2,2,2,  # b0 - b7 
2,2,2,2,2,2,2,2,  # b8 - bf 
2,2,2,2,2,2,2,2,  # c0 - c7 
2,2,2,2,2,2,2,2,  # c8 - cf 
2,2,2,2,2,2,2,2,  # d0 - d7 
2,2,2,2,2,2,2,2,  # d8 - df 
2,2,2,2,2,2,2,2,  # e0 - e7 
2,2,2,2,2,2,2,2,  # e8 - ef 
2,2,2,2,2,2,2,2,  # f0 - f7 
2,2,2,2,2,2,2,2,  # f8 - ff 
].freeze

ISO2022CN_st = [
EStart,     3,EError,EStart,EStart,EStart,EStart,EStart,# 00-07 
EStart,EError,EError,EError,EError,EError,EError,EError,# 08-0f 
EError,EError,EItsMe,EItsMe,EItsMe,EItsMe,EItsMe,EItsMe,# 10-17 
EItsMe,EItsMe,EItsMe,EError,EError,EError,     4,EError,# 18-1f 
EError,EError,EError,EItsMe,EError,EError,EError,EError,# 20-27 
     5,     6,EError,EError,EError,EError,EError,EError,# 28-2f 
EError,EError,EError,EItsMe,EError,EError,EError,EError,# 30-37 
EError,EError,EError,EError,EError,EItsMe,EError,EStart,# 38-3f 
].freeze

ISO2022CNCharLenTable = [0, 0, 0, 0, 0, 0, 0, 0, 0].freeze

ISO2022CNSMModel = {'classTable' => ISO2022CN_cls,
    'classFactor' => 9,
    'stateTable' => ISO2022CN_st,
    'charLenTable' => ISO2022CNCharLenTable,
    'name' => "ISO-2022-CN"
  }.freeze

ISO2022JP_cls = [
2,0,0,0,0,0,0,0,  # 00 - 07 
0,0,0,0,0,0,2,2,  # 08 - 0f 
0,0,0,0,0,0,0,0,  # 10 - 17 
0,0,0,1,0,0,0,0,  # 18 - 1f 
0,0,0,0,7,0,0,0,  # 20 - 27 
3,0,0,0,0,0,0,0,  # 28 - 2f 
0,0,0,0,0,0,0,0,  # 30 - 37 
0,0,0,0,0,0,0,0,  # 38 - 3f 
6,0,4,0,8,0,0,0,  # 40 - 47 
0,9,5,0,0,0,0,0,  # 48 - 4f 
0,0,0,0,0,0,0,0,  # 50 - 57 
0,0,0,0,0,0,0,0,  # 58 - 5f 
0,0,0,0,0,0,0,0,  # 60 - 67 
0,0,0,0,0,0,0,0,  # 68 - 6f 
0,0,0,0,0,0,0,0,  # 70 - 77 
0,0,0,0,0,0,0,0,  # 78 - 7f 
2,2,2,2,2,2,2,2,  # 80 - 87 
2,2,2,2,2,2,2,2,  # 88 - 8f 
2,2,2,2,2,2,2,2,  # 90 - 97 
2,2,2,2,2,2,2,2,  # 98 - 9f 
2,2,2,2,2,2,2,2,  # a0 - a7 
2,2,2,2,2,2,2,2,  # a8 - af 
2,2,2,2,2,2,2,2,  # b0 - b7 
2,2,2,2,2,2,2,2,  # b8 - bf 
2,2,2,2,2,2,2,2,  # c0 - c7 
2,2,2,2,2,2,2,2,  # c8 - cf 
2,2,2,2,2,2,2,2,  # d0 - d7 
2,2,2,2,2,2,2,2,  # d8 - df 
2,2,2,2,2,2,2,2,  # e0 - e7 
2,2,2,2,2,2,2,2,  # e8 - ef 
2,2,2,2,2,2,2,2,  # f0 - f7 
2,2,2,2,2,2,2,2,  # f8 - ff 
].freeze

ISO2022JP_st = [ 
EStart,     3,EError,EStart,EStart,EStart,EStart,EStart,# 00-07 
EStart,EStart,EError,EError,EError,EError,EError,EError,# 08-0f 
EError,EError,EError,EError,EItsMe,EItsMe,EItsMe,EItsMe,# 10-17 
EItsMe,EItsMe,EItsMe,EItsMe,EItsMe,EItsMe,EError,EError,# 18-1f 
EError,     5,EError,EError,EError,     4,EError,EError,# 20-27 
EError,EError,EError,     6,EItsMe,EError,EItsMe,EError,# 28-2f 
EError,EError,EError,EError,EError,EError,EItsMe,EItsMe,# 30-37 
EError,EError,EError,EItsMe,EError,EError,EError,EError,# 38-3f 
EError,EError,EError,EError,EItsMe,EError,EStart,EStart,# 40-47 
].freeze

ISO2022JPCharLenTable = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0].freeze

ISO2022JPSMModel = {'classTable' => ISO2022JP_cls,
    'classFactor' => 10,
    'stateTable' => ISO2022JP_st,
    'charLenTable' => ISO2022JPCharLenTable,
    'name' => "ISO-2022-JP"
  }.freeze

ISO2022KR_cls = [
2,0,0,0,0,0,0,0,  # 00 - 07 
0,0,0,0,0,0,0,0,  # 08 - 0f 
0,0,0,0,0,0,0,0,  # 10 - 17 
0,0,0,1,0,0,0,0,  # 18 - 1f 
0,0,0,0,3,0,0,0,  # 20 - 27 
0,4,0,0,0,0,0,0,  # 28 - 2f 
0,0,0,0,0,0,0,0,  # 30 - 37 
0,0,0,0,0,0,0,0,  # 38 - 3f 
0,0,0,5,0,0,0,0,  # 40 - 47 
0,0,0,0,0,0,0,0,  # 48 - 4f 
0,0,0,0,0,0,0,0,  # 50 - 57 
0,0,0,0,0,0,0,0,  # 58 - 5f 
0,0,0,0,0,0,0,0,  # 60 - 67 
0,0,0,0,0,0,0,0,  # 68 - 6f 
0,0,0,0,0,0,0,0,  # 70 - 77 
0,0,0,0,0,0,0,0,  # 78 - 7f 
2,2,2,2,2,2,2,2,  # 80 - 87 
2,2,2,2,2,2,2,2,  # 88 - 8f 
2,2,2,2,2,2,2,2,  # 90 - 97 
2,2,2,2,2,2,2,2,  # 98 - 9f 
2,2,2,2,2,2,2,2,  # a0 - a7 
2,2,2,2,2,2,2,2,  # a8 - af 
2,2,2,2,2,2,2,2,  # b0 - b7 
2,2,2,2,2,2,2,2,  # b8 - bf 
2,2,2,2,2,2,2,2,  # c0 - c7 
2,2,2,2,2,2,2,2,  # c8 - cf 
2,2,2,2,2,2,2,2,  # d0 - d7 
2,2,2,2,2,2,2,2,  # d8 - df 
2,2,2,2,2,2,2,2,  # e0 - e7 
2,2,2,2,2,2,2,2,  # e8 - ef 
2,2,2,2,2,2,2,2,  # f0 - f7 
2,2,2,2,2,2,2,2,  # f8 - ff 
].freeze

ISO2022KR_st = [ 
EStart,     3,EError,EStart,EStart,EStart,EError,EError,# 00-07 
EError,EError,EError,EError,EItsMe,EItsMe,EItsMe,EItsMe,# 08-0f 
EItsMe,EItsMe,EError,EError,EError,     4,EError,EError,# 10-17 
EError,EError,EError,EError,     5,EError,EError,EError,# 18-1f 
EError,EError,EError,EItsMe,EStart,EStart,EStart,EStart,# 20-27 
].freeze

ISO2022KRCharLenTable = [0, 0, 0, 0, 0, 0].freeze

ISO2022KRSMModel = {'classTable' => ISO2022KR_cls,
    'classFactor' => 6,
    'stateTable' => ISO2022KR_st,
    'charLenTable' => ISO2022KRCharLenTable,
    'name' => "ISO-2022-KR"
  }.freeze
end
