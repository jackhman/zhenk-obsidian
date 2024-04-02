## 1.集群状态查看

```
GET /_cat
#查看节点状况
GET /_cat/nodes?v

#查看健康状况
GET /_cat/health?v

#查看能查看什么
GET /_cat

#查看所有的index
GET /_cat/indices
```

## 2.Index操作

```
#7.8版本，index理解为表。数据直接在index下存储

GET stu1/_search

POST stu/_doc/1
{
  "id": "1001",
  "name": "jack",
  "hobby":{
    "name":"篮球",
    "years": 3
  }
}

#手动创建Index  需要在创建index时指定mapping信息
PUT stu
{
  "mappings": {
    "properties": {
      "id": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      },
      "hobby": {
        "properties": {
          "name": {
            "type": "text"
          },
          "years":{
            "type": "integer"
          }
        }
      }
    }
  }
}

#自动创建  直接向一个不存在的Index插入数据，在插入数据时，系统根据数据的类型，自动推断mapping，自动创建mapping
POST /stu1/1
{
   "name":"jack",
   "age":30
}



#查看所有的index
GET /_cat/indices

#查看某个index的信息
GET /_cat/indices/.kibana_1

#查看某个index的元数据信息
#aliases： 别名
#mappings： 类似schema(表结构)
#settings： 设置
GET  /stu1
#查看某个index的表结构
GET  /.kibana_1/_mapping

#查看某个index的别名
GET  /.kibana_1/_alias

#删除index
DELETE /stu1


#判断是否存在index  404 - Not Found代表不存在 ，200代表存在
HEAD /stu1

#改: 添加新字段
PUT /stu/_mapping
{
  "properties" : {
    "sex":{
      "type":"keyword"
    }
  }
}

#数据迁移

PUT stu1
{
  "mappings": {
    "properties": {
      "stuid": {
        "type": "keyword"
      },
      "name": {
        "type": "text"
      },
      "hobby": {
        "properties": {
          "name": {
            "type": "text"
          },
          "years":{
            "type": "integer"
          }
        }
      }
    }
  }
}

POST _reindex
{
  "source": {
    "index": "stu",
    "_source": ["id","name","hobby","sex"]
    
  },
  "dest": {
    "index": "stu1"
  }
}
















```

## 3.数据操作

```
#全表查询
GET stu/_search

#查询单条记录
GET stu/_doc/2

#明确指定id新增
POST /stu/_doc/2
{
  "name":"tom"
}

PUT /stu/_doc/3
{
  "name":"marry"
}

#随机指定id新增
#只能是POST
POST /stu/_doc
{
  "name":"nick"
}

#不行
PUT /stu/_doc
{
  "name":"sarra"
}


#全量修改 覆盖写
POST /stu/_doc/2
{
  "name":"jerry",
  "sex" : "M"
}

PUT /stu/_doc/2
{
  "name":"jerry1",
  "sex" : "F"
}
#增量修改，只修改指定的列
#有问题，会报错400
POST /stu/_doc/2
{
  "sex" : "M"
}

#400错误: 客户端发送的请求要么是url没写对，要么是格式不符合服务端的要求
POST /stu/_doc/2/_update
{
   "doc":{
     "sex" : "M"
   }
}

#PUT发不了
PUT /stu/_doc/2/_update
{
   "doc":{
     "sex" : "F"
   }
}

#删
DELETE /stu/_doc/2

#判断是否存在
HEAD /stu/_doc/2

```

## 4.切词

```

#切词(字符串)也是查询

# text(允许分词)   keyword(不允许分词)

# 默认的分词器，用来进行英文分词，按照空格分
GET _analyze
{
  "text": "I am a teacher"
}



# 汉语按照字切分
GET _analyze
{
  "text": "我是老师"
}



#ik_smart：  智能分词。切分的所有单词的总字数等于词的总字数，即输入总字数=输出总字数
GET _analyze
{
  "text": "我是中国人",
  "analyzer": "ik_smart"
}


#ik_max_word： 最大化分词。 输入总字数 <= 输出总字数
GET _analyze
{
  "text": "我是中国人",
  "analyzer": "ik_max_word"
}

#没有NLP(自然语言处理，没有人的情感，听不懂人话)功能
GET _analyze
{
  "text": "我喜欢洗屁股眼儿",
  "analyzer": "ik_max_word"
}
```

## 5.DSL练习

```

GET /test/_search

#第一种: REST   ； GET  /index/_search?参数1=值1&参数2=值2
#全表查询，按照年龄降序排序
#弊端:  url的长度是有限的(256位)
GET /test/_search?q=*&sort=age:desc



#第二种: DSL(特定领域语言)  ；  GET  /index/type/_search
#                               { 参数  }
GET /test/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "age": {
        "order": "desc"
      }
    }
  ]
}

#全表查询，按照年龄降序排序，再按照工资降序排序，只取前5条记录的empid，age，balance
GET /test/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "age": {
        "order": "desc"
      }
    },
    {
      "balance": {
        "order": "desc"
      }
    }
  ],
  "from": 0,
  "size": 5,
  "_source": ["empid","age","balance"]
}

#搜索hobby含有吃饭睡觉的员工
#用和hobby一致的切词算法，先对搜索的关键词进行切词,将切完后的 吃饭、睡觉到 hobby的倒排索引上去匹配
GET _analyze
{
  "analyzer":"ik_max_word",
  "text": "吃饭睡觉"
}

GET /test/_search
{
  "query": {
    "match": {
      "hobby": "吃饭睡觉"
    }
  }
}


#搜索工资是2000的员工
#只有text类型才能切词
GET /test/_search
{
  "query": {
    "match": {
      "balance": 2000
    }
  }
}

#官方不建议
#match一般都是对text类型进行检索
GET /test/_search
{
  "query": {
    "term": {
      "balance": 2000
    }
  }
}


#搜索hobby是“吃饭睡觉”的员工
GET /test/_search
{
  "query": {
    "match": {
      "hobby.keyword": "吃饭睡觉"
    }
  }
}

GET /test/_search
{
  "query": {
    "match_phrase": {
      "hobby": "吃饭睡觉"
    }
  }
}
#搜索name或hobby中带球的员工
GET /test/_search
{
  "query": {
    "multi_match": {
      "query": "球",
      "fields": ["name","hobby"]
    }
  }
}

#搜索男性中喜欢购物的员工
#在bool中可以写must(必须是)，must_not(必须不是),filter(过滤)，should(最好是)
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ]
    }
  }
}

#搜索男性中喜欢购物，还不能爱去酒吧的员工
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ]
    }
  }
}
#搜索男性中喜欢购物，还不能爱去酒吧的员工，年龄最好在20-30之间
#should如果匹配，加分
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ],
      "should": [
        {
          "range": {
            "age": {
              "gte": 20,
              "lte": 30
            }
          }
        }
      ]
    }
  }
}

#搜索男性中喜欢购物，还不能爱去酒吧的员工，最好在20-30之间，不要40岁以上的
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ],
      "should": [
        {
          "range": {
            "age": {
              "gte": 20,
              "lte": 30
            }
          }
        }
      ],
      "filter": [
        {
          "range": {
            "age": {
              
              "lte": 40
            }
          }
        }
      ]
    }
  }
}
#搜索Nick
GET /test/_search
{
  "query": {
    "fuzzy": {
      "name": "Dick"
    }
  }
}



```

## 6.聚合练习

```

GET /test/_search

#第一种: REST   ； GET  /index/_search?参数1=值1&参数2=值2
#全表查询，按照年龄降序排序
#弊端:  url的长度是有限的(256位)
GET /test/_search?q=*&sort=age:desc



#第二种: DSL(特定领域语言)  ；  GET  /index/type/_search
#                               { 参数  }
GET /test/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "age": {
        "order": "desc"
      }
    }
  ]
}

#全表查询，按照年龄降序排序，再按照工资降序排序，只取前5条记录的empid，age，balance
GET /test/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "age": {
        "order": "desc"
      }
    },
    {
      "balance": {
        "order": "desc"
      }
    }
  ],
  "from": 0,
  "size": 5,
  "_source": ["empid","age","balance"]
}

#搜索hobby含有吃饭睡觉的员工
#用和hobby一致的切词算法，先对搜索的关键词进行切词,将切完后的 吃饭、睡觉到 hobby的倒排索引上去匹配
GET _analyze
{
  "analyzer":"ik_max_word",
  "text": "吃饭睡觉"
}

GET /test/_search
{
  "query": {
    "match": {
      "hobby": "吃饭睡觉"
    }
  }
}


#搜索工资是2000的员工
#只有text类型才能切词
GET /test/_search
{
  "query": {
    "match": {
      "balance": 2000
    }
  }
}

#官方不建议
#match一般都是对text类型进行检索
GET /test/_search
{
  "query": {
    "term": {
      "balance": 2000
    }
  }
}


#搜索hobby是“吃饭睡觉”的员工
GET /test/_search
{
  "query": {
    "match": {
      "hobby.keyword": "吃饭睡觉"
    }
  }
}

GET /test/_search
{
  "query": {
    "match_phrase": {
      "hobby": "吃饭睡觉"
    }
  }
}
#搜索name或hobby中带球的员工
GET /test/_search
{
  "query": {
    "multi_match": {
      "query": "球",
      "fields": ["name","hobby"]
    }
  }
}

#搜索男性中喜欢购物的员工
#在bool中可以写must(必须是)，must_not(必须不是),filter(过滤)，should(最好是)
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ]
    }
  }
}

#搜索男性中喜欢购物，还不能爱去酒吧的员工
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ]
    }
  }
}
#搜索男性中喜欢购物，还不能爱去酒吧的员工，年龄最好在20-30之间
#should如果匹配，加分
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ],
      "should": [
        {
          "range": {
            "age": {
              "gte": 20,
              "lte": 30
            }
          }
        }
      ]
    }
  }
}

#搜索男性中喜欢购物，还不能爱去酒吧的员工，最好在20-30之间，不要40岁以上的
GET /test/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "gender": {
              "value": "男"
            }
          }
        },
        {
          "match": {
            "hobby": "购物"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "hobby": "酒吧"
          }
        }
      ],
      "should": [
        {
          "range": {
            "age": {
              "gte": 20,
              "lte": 30
            }
          }
        }
      ],
      "filter": [
        {
          "range": {
            "age": {
              
              "lte": 40
            }
          }
        }
      ]
    }
  }
}
#搜索Nick
GET /test/_search
{
  "query": {
    "fuzzy": {
      "name": "Dick"
    }
  }
}


#统计男女员工各多少人
# 如果聚合后，聚合列的基数为x,希望取到全部数据，size >= x
#聚合时，如果text类型，无法聚合，建议使用keyword类型
GET /test/_search
{
  "aggs": {
    "gendercount": {
      "terms": {
        "field": "gender.keyword",
        "size": 10
      }
    }
  }
}

#统计喜欢购物的男女员工各多少人
GET /test/_search
{
  "query": {
    "match": {
      "hobby": "购物"
    }
  }, 
  "aggs": {
    "gendercount": {
      "terms": {
        "field": "gender.keyword",
        "size": 10
      }
    }
  }
}


#统计喜欢购物的男女员工各多少人，及这些人总体的平均年龄
GET /test/_search
{
  "query": {
    "match": {
      "hobby": "购物"
    }
  }, 
  "aggs": {
    "gendercount": {
      "terms": {
        "field": "gender.keyword",
        "size": 10
      }
    },
    "avgage":{
      "avg": {
        "field": "age"
      }
    }
  }
}


#统计喜欢购物的男女员工各多少人，及这些人不同性别的平均年龄
GET /test/_search
{
  "query": {
    "match": {
      "hobby": "购物"
    }
  },
  "aggs": {
    "gendercount": {
      "terms": {
        "field": "gender.keyword",
        "size": 10
      },
      "aggs": {
        "avgage": {
          "avg": {
            "field": "age"
          }
        }
      }
    }
  }
}





```

## 7.别名练习

```
#建索引时直接声明
PUT movie_index
{  
  "aliases": {
    "movie1": {},
    "movie2": {}
  }, 
  "mappings": {
      "properties": {
        "id":{
          "type": "long"
        },
        "name":{
          "type": "text",
          "analyzer": "ik_smart"
        }
      }
  }
}

POST /movie1/_doc/1
{
  "name":"《猫和老鼠》"
}

GET /movie2/_search

#为已存在的索引增加别名
POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "movie_index",
        "alias": "movie3"
      }
    }
  ]
}



#查询别名
#查询当前所有的别名
GET /_cat/aliases?v

#查某个index的别名
GET /movie_index/_alias 

#删除别名
POST _aliases
{
  "actions": [
    {
      "remove": {
        "index": "movie_index",
        "alias": "movie3"
      }
    }
  ]
}

#修改别名
POST _aliases
{
  "actions": [
    {
      "remove": {
        "index": "movie_index",
        "alias": "movie2"
      }
    },
    {
      "add": {
        "index": "movie_index",
        "alias": "movie22"
      }
    }
  ]
}

#创建子集
POST _aliases
{
  "actions": [
    {
      "add": {
        "index": "test",
        "alias": "manindex",
        "filter": {
           "term": {
             "gender": "男"
           }
        }
      }
    }
  ]
}

GET /manindex/_search

```

## 8.模板操作

```
#查看模板
#每个模板都有index_patterns属性，这个属性代表如果你要创建的index名称和
#某个模板的index_patterns匹配了，就会使用模板定义的属性(mappings,alises,settings)帮你创建index
GET /_cat/templates?v

#创建模板
PUT _template/template_movie
{
  "index_patterns": ["movie*"],
  "aliases" : { 
    "{index}-query": {},
    "movie-query":{}
  },
  "mappings": { 
      "properties": {
        "id": {
          "type": "keyword"
        },
        "movie_name": {
          "type": "text",
          "analyzer": "ik_smart"
        }
      }
    }
}
#删除模板
DELETE  _template/template_movie

#应用模板
POST /movie220712/_doc/1
{
  "price": 30
}

GET movie220712
```

