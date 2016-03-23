/*
Navicat MySQL Data Transfer

Source Server         : youchuang
Source Server Version : 50626
Source Host           : localhost:3306
Source Database       : test

Target Server Type    : MYSQL
Target Server Version : 50626
File Encoding         : 65001

Date: 2016-03-09 10:23:28
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for answer
-- ----------------------------
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '问题回复ID',
  `uid` int(11) NOT NULL COMMENT '问题发布人的ID',
  `qid` int(11) NOT NULL COMMENT '发布的问题的ID',
  `content` text NOT NULL COMMENT '问题的回答内容',
  `status` tinyint(3) DEFAULT '0' COMMENT '问题回答与否的状态',
  `reason` varchar(255) DEFAULT NULL COMMENT '问题不采纳的理由',
  `time` int(11) DEFAULT '0' COMMENT '问题回复时间',
  `rid` int(11) NOT NULL COMMENT '问题回复人的ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of answer
-- ----------------------------
INSERT INTO `answer` VALUES ('1', '1', '1', 'edfdffafdfasf', '0', 'dfdsafsdaf', '2323232', '2');
INSERT INTO `answer` VALUES ('2', '2', '1', 'ererrrrrrryyy', '0', 'dsfasdf', '1341414', '1');
INSERT INTO `answer` VALUES ('3', '3', '3', 'bbbb', '0', null, '13413413', '2');
INSERT INTO `answer` VALUES ('4', '3', '3', 'bbbb', '0', null, '13413413', '2');
INSERT INTO `answer` VALUES ('5', '3', '3', 'bbbb', '0', null, '13413413', '2');
INSERT INTO `answer` VALUES ('6', '3', '3', 'bbbb', '0', null, '13413413', '2');

-- ----------------------------
-- Table structure for appeal
-- ----------------------------
DROP TABLE IF EXISTS `appeal`;
CREATE TABLE `appeal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '申诉ID',
  `qid` int(11) NOT NULL COMMENT '问题ID',
  `uid` int(11) NOT NULL COMMENT '问题发布人ID',
  `rid` int(11) NOT NULL COMMENT '申诉人ID',
  `content` text CHARACTER SET utf8 COMMENT '申诉内容',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '申诉状态',
  `kereply` text CHARACTER SET utf8 COMMENT '客服回复内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of appeal
-- ----------------------------
INSERT INTO `appeal` VALUES ('1', '1', '1', '2', '他无赖。。。。。', '0', '好的，先生');

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) CHARACTER SET utf8 NOT NULL,
  `content` text CHARACTER SET utf8 NOT NULL,
  `addtime` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('1', 'dsafadf', 'fdsafa', '1000000000');
INSERT INTO `article` VALUES ('2', '魂牵梦萦载', '塔顶远东地区要', '1526396574');
INSERT INTO `article` VALUES ('3', 'fdafaf', 'fdasfas', '1538596748');
INSERT INTO `article` VALUES ('4', '发大水发大厦', '大法师发大水发发', '1538596748');

-- ----------------------------
-- Table structure for article_cate
-- ----------------------------
DROP TABLE IF EXISTS `article_cate`;
CREATE TABLE `article_cate` (
  `cname` varchar(255) CHARACTER SET utf8 NOT NULL,
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of article_cate
-- ----------------------------
INSERT INTO `article_cate` VALUES ('生活', '1', '1');
INSERT INTO `article_cate` VALUES ('学习', '2', '2');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '问题的分类',
  `cname` varchar(255) NOT NULL COMMENT '分类的名称',
  `pid` int(11) NOT NULL COMMENT '上级ID',
  `cid` varchar(255) NOT NULL COMMENT '该问题所在级别（细分）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '生活', '0', '0');
INSERT INTO `category` VALUES ('2', '学习', '0', '0');

-- ----------------------------
-- Table structure for fan
-- ----------------------------
DROP TABLE IF EXISTS `fan`;
CREATE TABLE `fan` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '粉丝ID',
  `uid` int(11) NOT NULL COMMENT '关注人ID',
  `rid` int(11) NOT NULL COMMENT '被关注人的ID',
  `time` int(11) NOT NULL COMMENT '成为粉丝的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fan
-- ----------------------------
INSERT INTO `fan` VALUES ('1', '1', '2', '123132323');
INSERT INTO `fan` VALUES ('2', '2', '1', '231414314');
INSERT INTO `fan` VALUES ('3', '1', '2', '14234321');
INSERT INTO `fan` VALUES ('4', '1', '2', '14234321');
INSERT INTO `fan` VALUES ('5', '1', '1', '1538596745');
INSERT INTO `fan` VALUES ('6', '1', '1', '1538596745');
INSERT INTO `fan` VALUES ('7', '1', '2', '121465213');
INSERT INTO `fan` VALUES ('8', '1', '2', '121465213');
INSERT INTO `fan` VALUES ('9', '1', '2', '123564132');
INSERT INTO `fan` VALUES ('10', '1', '2', '123564132');
INSERT INTO `fan` VALUES ('11', '1', '2', '123564132');

-- ----------------------------
-- Table structure for migration
-- ----------------------------
DROP TABLE IF EXISTS `migration`;
CREATE TABLE `migration` (
  `version` varchar(180) CHARACTER SET utf8 NOT NULL,
  `apply_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of migration
-- ----------------------------
INSERT INTO `migration` VALUES ('m000000_000000_base', '1456997799');

-- ----------------------------
-- Table structure for purchase
-- ----------------------------
DROP TABLE IF EXISTS `purchase`;
CREATE TABLE `purchase` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '消费记录ID',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `qid` int(11) NOT NULL COMMENT '问题ID',
  `status` tinyint(3) NOT NULL COMMENT '增减状态（0：减；1：增）',
  `reason` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '牛豆增减原因',
  `number` int(11) NOT NULL DEFAULT '0' COMMENT '牛豆的增减数量',
  `time` int(11) NOT NULL COMMENT '消费时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of purchase
-- ----------------------------
INSERT INTO `purchase` VALUES ('1', '1', '1', '1', 'ewfwefwef', '1', '121313');
INSERT INTO `purchase` VALUES ('2', '2', '1', '1', 'erqwerewrewr', '5', '12312321');

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '问题的ID',
  `uid` int(11) NOT NULL COMMENT '问题发布者的ID',
  `cid` tinyint(3) NOT NULL COMMENT '问题所属分类',
  `givend` int(11) NOT NULL DEFAULT '0' COMMENT '问题所悬赏的牛豆',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '问题回答与否的状态',
  `ctime` int(11) DEFAULT NULL COMMENT '问题发布的时间',
  `gtime` int(11) DEFAULT NULL COMMENT '问题的修改时间',
  `content` text NOT NULL COMMENT '问题的内容',
  `atime` int(11) DEFAULT NULL COMMENT '问题采纳的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES ('1', '1', '1', '0', '1', '121212121', '32132131', 'fsdfadsfasdfsad', '31313131');
INSERT INTO `question` VALUES ('2', '2', '1', '3', '1', '12312312', null, '21312312adasfdsaf', null);
INSERT INTO `question` VALUES ('3', '3', '1', '2', '0', '11110010', null, '啊是科技活动', null);
INSERT INTO `question` VALUES ('4', '1', '1', '2', '0', null, null, 'bbbb', null);
INSERT INTO `question` VALUES ('5', '5', '5', '2', '0', '12341234', null, '啊哈哈哈哈', null);
INSERT INTO `question` VALUES ('6', '6', '6', '2', '0', '1457487754', null, '啊哈哈哈哈', null);
INSERT INTO `question` VALUES ('7', '6', '6', '2', '0', '1457487843', null, '啊哈哈哈哈', null);
INSERT INTO `question` VALUES ('8', '3', '0', '1', '0', '1457487926', null, '水电费水电费', null);

-- ----------------------------
-- Table structure for reply
-- ----------------------------
DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT ' 评分回复',
  `content` text CHARACTER SET utf8 COMMENT '评分内容',
  `uid` int(11) NOT NULL COMMENT '问题发布人ID',
  `rid` int(11) NOT NULL COMMENT '评分人ID',
  `qid` int(11) NOT NULL COMMENT '问题ID',
  `time` int(11) NOT NULL COMMENT '评分时间',
  `colligate` int(11) NOT NULL DEFAULT '3' COMMENT '综合评分(3:良，2:中,1:差)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of reply
-- ----------------------------
INSERT INTO `reply` VALUES ('1', '真棒', '1', '2', '1', '12131312', '3');
INSERT INTO `reply` VALUES ('2', '谢谢您的好评', '2', '1', '1', '12312321', '3');

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '举报ID',
  `qid` int(11) NOT NULL COMMENT '问题ID',
  `uid` int(11) NOT NULL COMMENT '问题发布人ID',
  `rid` int(11) NOT NULL COMMENT '举报人ID',
  `reason` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '举报原因',
  `time` int(11) NOT NULL COMMENT '举报时间',
  `status` tinyint(3) NOT NULL DEFAULT '0' COMMENT '举报状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of report
-- ----------------------------
INSERT INTO `report` VALUES ('1', '1', '1', '2', 'edqad', '13243434', '0');
INSERT INTO `report` VALUES ('2', '1', '2', '1', '拆零', '21312321', '0');

-- ----------------------------
-- Table structure for score
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '回答问题的评分ID',
  `grade` varchar(255) DEFAULT NULL COMMENT '[1,2,3]服务评分，速度评分，质量评分',
  `colligate` tinyint(3) DEFAULT NULL COMMENT '综合评分（良 中 差）',
  `qid` int(11) NOT NULL COMMENT '问题发布ID',
  `uid` int(11) NOT NULL COMMENT '问题发布者（被评价人）ID',
  `addnd` int(11) NOT NULL DEFAULT '0' COMMENT '打赏的牛豆',
  `time` int(11) DEFAULT NULL COMMENT '评分时间',
  `content` varchar(255) DEFAULT NULL COMMENT '采纳人的评价内容',
  `rid` int(11) NOT NULL COMMENT '问题回复人（评价人）ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES ('1', '[1,2,4]', '2', '1', '1', '0', '1232131213', 'fjaosdijfoa', '1');
INSERT INTO `score` VALUES ('2', '[2,4,5]', '3', '2', '2', '0', '1213213123', 'fgrgfsdhdghf', '1');
INSERT INTO `score` VALUES ('3', null, null, '1', '1', '1', '122121', null, '2');

-- ----------------------------
-- Table structure for set_question
-- ----------------------------
DROP TABLE IF EXISTS `set_question`;
CREATE TABLE `set_question` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户抢题ID',
  `cate` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT '选题设置（1，2，3）',
  `nd` int(11) NOT NULL DEFAULT '1' COMMENT '牛豆数高于多少在牛豆(1,2)',
  `bad` int(11) NOT NULL DEFAULT '1' COMMENT '评分数低于多少的（1，2，3，4，5）',
  `time` int(11) NOT NULL DEFAULT '0' COMMENT '设置题目的时间',
  `uid` int(11) NOT NULL COMMENT '抢题用户ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of set_question
-- ----------------------------
INSERT INTO `set_question` VALUES ('1', '1,3,4', '1', '1', '0', '1');
INSERT INTO `set_question` VALUES ('2', '1,2,3', '2', '5', '1234143131', '2');
INSERT INTO `set_question` VALUES ('3', '1,2,0', '2', '3', '14234321', '3');
INSERT INTO `set_question` VALUES ('4', '1,2,0', '2', '3', '14234321', '4');
INSERT INTO `set_question` VALUES ('5', '2,3,4', '2', '3', '14234321', '1');
INSERT INTO `set_question` VALUES ('6', '2,3,4', '2', '3', '14234321', '1');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(255) DEFAULT NULL COMMENT '用户手机号作为账号',
  `password_hash` varchar(32) DEFAULT NULL COMMENT '用户密码',
  `status` smallint(5) NOT NULL COMMENT '用户状态信息',
  `nickname` varchar(255) NOT NULL COMMENT '用户的昵称',
  `sex` varchar(255) NOT NULL COMMENT '性别',
  `area` varchar(255) NOT NULL COMMENT '用户所属地区',
  `email` char(255) DEFAULT NULL COMMENT '用户邮箱',
  `alipay` varchar(255) DEFAULT NULL COMMENT '用户的支付宝账号',
  `pic` varchar(255) DEFAULT NULL COMMENT '用户头像',
  `nd` int(11) NOT NULL DEFAULT '0' COMMENT '用户的牛豆',
  `identity` varchar(255) DEFAULT NULL COMMENT '用户身份',
  `label` text COMMENT '用户标签（擅长，特长）',
  `introduce` text COMMENT '用户介绍',
  `thirdpassword` varchar(255) DEFAULT NULL COMMENT '第三方（微信，QQ）密码',
  `thirdname` varchar(255) DEFAULT NULL COMMENT '第三方账号',
  `auth_key` varchar(32) NOT NULL DEFAULT '0',
  `display_name` varchar(50) NOT NULL DEFAULT '1',
  `password_reset_token` varchar(255) DEFAULT NULL,
  `role` smallint(5) NOT NULL DEFAULT '1',
  `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `hxname` varchar(255) DEFAULT NULL COMMENT '环信用户名',
  `hxpassword` varchar(255) DEFAULT NULL COMMENT '环信密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '111', '111111', '0', 'fdsaf', 'fasdf', 'fdsaf', '122', '红包', 'sdfs', '0', 'ffsdaf', 'fdsf', 'fasdfs', 'fsdfsd', '微信', '1', 'afa', null, '0', '0', '0', null, null);
INSERT INTO `user` VALUES ('2', '222', '222222', '0', 'shfu', 'man', 'aofsdjfoi', '12321321@qq.com', '1231234141', 'sadfsda', '0', 'FJDSOFJSDOIF', 'fjdsaf', 'sadfsadfsg', 'fsd', 'QQ', '1', 'nani', null, '1', '1324234', '12312', null, null);
INSERT INTO `user` VALUES ('3', '', '', '0', 'ratg', 'agf', 'gffadg', 'gfadgfdag', 'trrtsdfg', 'ggsgsdf', '0', 'gfsdgdsf', 'gsdfg', 'sgdfg', 'fsdf', 'QQ', '0', '1', null, '1', '0', '0', null, null);
