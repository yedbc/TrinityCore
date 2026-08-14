-- In-game Shop (BattlePay) server-defined products.
-- Promoted from sql/custom/battlepay/battlepay_product.sql to an auto-applying world update so a
-- tester's DB gets it on startup without a manual import (sql/custom is never applied by the core).
-- Each row maps a catalog productID (advertised to the client in the shipped GET_PRODUCT_LIST_RESPONSE
-- blob, data/battlepay/product_list_68275.bin) to how it is paid for and what it grants.
--   costMoney            : price in copper (0 = free)
--   costItemId/Count     : optional token-item price (0 = none)
--   grantType            : 1 = item, 2 = spell (mount/toy/appearance)
--   grantId/grantCount   : what to deliver
-- The productIds MUST match the shipped blob. Regenerate both together with gen_shop_catalog.py.
-- Idempotent: re-running (or a re-applied hash) restores exactly these rows.

CREATE TABLE IF NOT EXISTS `battlepay_product` (
  `productId`     INT UNSIGNED     NOT NULL,
  `costMoney`     BIGINT UNSIGNED  NOT NULL DEFAULT 0,
  `costItemId`    INT UNSIGNED     NOT NULL DEFAULT 0,
  `costItemCount` INT UNSIGNED     NOT NULL DEFAULT 0,
  `grantType`     TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `grantId`       INT UNSIGNED     NOT NULL DEFAULT 0,
  `grantCount`    INT UNSIGNED     NOT NULL DEFAULT 1,
  `name`          VARCHAR(100)     NOT NULL DEFAULT '',
  PRIMARY KEY (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `battlepay_product` WHERE `productId` IN (1616893, 1616898, 841541, 132620);
INSERT INTO `battlepay_product`
  (`productId`, `costMoney`, `costItemId`, `costItemCount`, `grantType`, `grantId`, `grantCount`, `name`) VALUES
(1616893, 500000,  0, 0, 1, 4500, 1,  'Traveler''s Tundra Pack'),
(1616898, 10000,   0, 0, 1, 2589, 20, 'Crate of Linen Cloth'),
(841541,  5000,    0, 0, 1, 159,  20, 'Case of Spring Water'),
(132620,  1000000, 0, 0, 2, 458,  1,  'Reins of the Brown Horse');

-- ---- warband/phase9-delves: Seafarer's Tomb quest spawns (same filename, disjoint content) ----

SET @CGUID := 3000098;

-- Creature
DELETE FROM `creature` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+6;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `PhaseId`, `PhaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `VerifiedBuild`) VALUES
(@CGUID+0, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4441.5556640625, 3810.943603515625, -82.11639404296875, 2.042035102844238281, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+1, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4461.6025390625, 3801.744873046875, -82.2079620361328125, 0.855211317539215087, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+2, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4463.51025390625, 3804.5859375, -82.805877685546875, 0, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+3, 39887, 0, 4815, 5051, '0', 0, 0, 0, 0, -4440.31591796875, 3817.341064453125, -82.7362289428710937, 2.007128715515136718, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Captain Taylor (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+4, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4440.72900390625, 3813.7587890625, -82.498687744140625, 4.031710624694824218, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+5, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4452.58837890625, 3803.559814453125, -81.7989654541015625, 2.600540637969970703, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453), -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)
(@CGUID+6, 40664, 0, 4815, 5051, '0', 0, 0, 0, 0, -4436.6337890625, 3815.634521484375, -82.4793853759765625, 2.670353651046752929, 120, 0, 0, 0, NULL, NULL, NULL, NULL, 68453); -- Recovering Soldier (Area: Seafarer's Tomb - Difficulty: 0) CreateObject1 (Auras: 49415 - Generic Quest Invisibility 2)

-- SpellArea (update quest_ender)
DELETE FROM `spell_area` WHERE `spell` = 74145 AND `area` IN (5051,5052,5012);
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `flags`, `quest_start_status`, `quest_end_status`) VALUE
(74145, 5051, 14482, 25281, 0, 0, 2, 3, 66, 11), -- (Cast) SpellID: 74145 (Kelp Forest Quest Invisibility Detection 1)
(74145, 5052, 14482, 25281, 0, 0, 2, 3, 66, 11), -- (Cast) SpellID: 74145 (Kelp Forest Quest Invisibility Detection 1)
(74145, 5012, 14482, 25281, 0, 0, 2, 3, 66, 11); -- (Cast) SpellID: 74145 (Kelp Forest Quest Invisibility Detection 1)

-- SpellArea
DELETE FROM `spell_area` WHERE `spell` = 74146 AND `area` IN (5051,5052,5012);
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `flags`, `quest_start_status`, `quest_end_status`) VALUE
(74146, 5051, 25281, 0, 0, 0, 2, 3, 64, 11), -- 74146 (Kelp Forest Quest Invisibility Detection 2)
(74146, 5052, 25281, 0, 0, 0, 2, 3, 64, 11), -- 74146 (Kelp Forest Quest Invisibility Detection 2)
(74146, 5012, 25281, 0, 0, 0, 2, 3, 64, 11); -- 74146 (Kelp Forest Quest Invisibility Detection 2)

-- Template
UPDATE `creature_template` SET `npcflag`=1, `unit_flags3`=0x1 WHERE `entry`=40664; -- Recovering Soldier
UPDATE `creature_template` SET `unit_flags3`=0x1 WHERE `entry`=39887; -- Captain Taylor

-- Template Addon
DELETE FROM `creature_template_addon` WHERE `entry` IN (39887 /*39887 (Captain Taylor) - Generic Quest Invisibility 2*/, 40664 /*40664 (Recovering Soldier) - Generic Quest Invisibility 2*/);
INSERT INTO `creature_template_addon` (`entry`, `PathId`, `mount`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvpFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(39887, 0, 0, 8, 0, 1, 1, 0, 0, 0, 0, 0, 0, '49415'), -- 39887 (Captain Taylor) - Generic Quest Invisibility 2
(40664, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '49415'); -- 40664 (Recovering Soldier) - Generic Quest Invisibility 2

-- Difficulty
UPDATE `creature_template_difficulty` SET `ContentTuningID`=53, `StaticFlags1`=0x10000000, `VerifiedBuild`=68453 WHERE (`Entry`=39887 AND `DifficultyID`=0); -- 39887 (Captain Taylor) - CanSwim
UPDATE `creature_template_difficulty` SET `ContentTuningID`=53, `StaticFlags1`=0x10000000, `VerifiedBuild`=68453 WHERE (`Entry`=40664 AND `DifficultyID`=0); -- 40664 (Recovering Soldier) - CanSwim

-- Gossip
DELETE FROM `creature_template_gossip` WHERE (`CreatureID`=40664 AND `MenuID`=11421);
INSERT INTO `creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES
(40664, 11421, 68453); -- Recovering Soldier
