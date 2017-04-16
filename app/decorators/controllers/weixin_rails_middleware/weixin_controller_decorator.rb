# encoding: utf-8
# 1, @weixin_message: 获取微信所有参数.
# 2, @weixin_public_account: 如果配置了public_account_class选项,则会返回当前实例,否则返回nil.
# 3, @keyword: 目前微信只有这三种情况存在关键字: 文本消息, 事件推送, 接收语音识别结果
WeixinRailsMiddleware::WeixinController.class_eval do
  before_action :get_open_id, :get_base_url

  def reply
    render xml: send("response_#{@weixin_message.MsgType}_message", {})
  end

  private

    def response_text_message(options={})
      user = User.where(open_id: @open_id).first_or_create
      bill = Bill.where(user_id: user.id).first_or_create
      case
      when @keyword.match(/[Qq]/)
        remove_item(bill.items.first)
      when @keyword.match(/[Mm]/)
        menu_response
      else
        if bill.add_item(@keyword)
          item = bill.items.first
          add_item_response(item)
        else
          reply_error_msg
        end
      end
    end

    def response_event_message(options={})
      event_type = @weixin_message.Event
      method_name = "handle_#{event_type.downcase}_event"
      if self.respond_to? method_name, true
        send(method_name)
      else
        send("handle_undefined_event")
      end
    end

    # 关注公众账号
    def handle_subscribe_event
      User.where(open_id: @open_id).first_or_create
      reply_subscribe_msg
    end

    # 取消关注
    def handle_unsubscribe_event
      Rails.logger.info("取消关注")
    end

    # 帮助文档: https://github.com/lanrion/weixin_authorize/issues/22

    # 由于群发任务提交后，群发任务可能在一定时间后才完成，因此，群发接口调用时，仅会给出群发任务是否提交成功的提示，若群发任务提交成功，则在群发任务结束时，会向开发者在公众平台填写的开发者URL（callback URL）推送事件。

    # 推送的XML结构如下（发送成功时）：

    # <xml>
    # <ToUserName><![CDATA[gh_3e8adccde292]]></ToUserName>
    # <FromUserName><![CDATA[oR5Gjjl_eiZoUpGozMo7dbBJ362A]]></FromUserName>
    # <CreateTime>1394524295</CreateTime>
    # <MsgType><![CDATA[event]]></MsgType>
    # <Event><![CDATA[MASSSENDJOBFINISH]]></Event>
    # <MsgID>1988</MsgID>
    # <Status><![CDATA[sendsuccess]]></Status>
    # <TotalCount>100</TotalCount>
    # <FilterCount>80</FilterCount>
    # <SentCount>75</SentCount>
    # <ErrorCount>5</ErrorCount>
    # </xml>
    def handle_masssendjobfinish_event
      Rails.logger.info("回调事件处理")
    end

    # <xml>
    # <ToUserName><![CDATA[gh_7f083739789a]]></ToUserName>
    # <FromUserName><![CDATA[oia2TjuEGTNoeX76QEjQNrcURxG8]]></FromUserName>
    # <CreateTime>1395658920</CreateTime>
    # <MsgType><![CDATA[event]]></MsgType>
    # <Event><![CDATA[TEMPLATESENDJOBFINISH]]></Event>
    # <MsgID>200163836</MsgID>
    # <Status><![CDATA[success]]></Status>
    # </xml>
    # 推送模板信息回调，通知服务器是否成功推送
    def handle_templatesendjobfinish_event
      Rails.logger.info("回调事件处理")
    end

    # 未定义的事件处理
    def handle_undefined_event
      Rails.logger.info("回调事件处理")
    end

    def get_open_id
      @open_id = @weixin_message.FromUserName
    end

    def get_base_url
      @base_url = request.base_url
    end

    def reply_subscribe_msg
      str = <<-str
欢迎关注我的账单
================
按以下格式记账:
早餐 10
打车 20
淘宝 50
输入Q即可删除最后一条记录
输入M即可召唤菜单
<a href='#{@base_url}/items?open_id=#{@open_id}'>账单明细</a>快捷入口
      str
      reply_text_message(str)
    end

    def add_item_response(item)
      str = <<-str
===== SUCCESS =====
【时间】#{item.created_at.strftime('%m-%d %H:%m')}
【金额】#{item.amount.abs}
【类别】#{t("items.item_type.#{item.item_type}")}
【备注】#{item.memo}
==== 本月支出 #{item.bill.month_total_expense.abs} 元 ====
==== 本月收入 #{item.bill.month_total_income} 元 ====
输入Q即可删除最后一条记录
输入M即可召唤菜单
<a href='#{@base_url}/items?open_id=#{@open_id}'>账单明细</a>快捷入口
      str
      reply_text_message(str)
    end

    def reply_error_msg
      str = <<-str
无法识别你输入的内容
================
按以下格式记账:
早餐 10
打车 20
淘宝 50
输入Q即可删除最后一条记录
输入M即可召唤菜单
<a href='#{@base_url}/items?open_id=#{@open_id}'>账单明细</a>快捷入口
      str
      reply_text_message(str)
    end

    def remove_item(item)
      if item.destroy
        reply_text_message("删除成功:)")
      else
        reply_text_message("删除失败，请重试")
      end
    end

    def menu_response
      articles = [generate_report, generate_list]
      reply_news_message(articles)
    end

    def generate_list
      generate_article('账单明细', '账单明细', nil, "#{@base_url}/items?open_id=#{@open_id}")
    end

    def generate_report
      generate_article('账单统计', '账单统计', nil, "#{@base_url}/items/stat?open_id=#{@open_id}")
    end

end
