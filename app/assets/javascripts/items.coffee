init_data = ()->
  $.ajax
    url: "/items/fetch_data"
    data: {open_id: $('#open_id').val(), month: $("#month").val()}
    success: (data)->
      eval(data)

config = (dom, range)->
  type: 'line',
  data: {
    labels: dom.data('labels'),
    datasets: [
      {
        label: "支出",
        data: dom.data('expense'),
        backgroundColor: 'rgba(54, 162, 235, 0.5)' for x in [1..range]
      },
      {
        label: "收入",
        data: dom.data('incomes'),
        backgroundColor: 'rgba(75, 192, 192, 0.5)' for x in [1..range]
      }
    ]
  },
  options: {
    title: {
      display: true,
      text: "总支出(#{dom.data('total-expense')})元 / 总收入(#{dom.data('total-incomes')})元"
    }
    scales: {
      xAxes: [{
          stacked: true
      }],
      yAxes: [{
          stacked: true
      }]
    }
  }

set_chart = ()->
  monthly_temp = $.extend(true, {}, config($('#monthly_chart'), 12))
  monthly_temp.type = 'bar'
  monthly_chart = new Chart($('#monthly_chart'), monthly_temp)
$ ->
  if $('.pagination').length > 0
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 140
        $('.pagination').text('fetching data.....')
        $.getScript(url)

  $(document).on 'touchstart', 'tr.item span', ()->
    item_id = $(this).parents('tr').data('id')
    $.ajax
      url: "/items/#{item_id}/edit"
      success: (data)->
        eval(data)

  if $('#myChart').length > 0
    init_data()

    $(document).on 'touchstart', '.dropdown-menu li', ()->
      $("#month").val($(this).text())
      init_data()

  $(document).on 'change', '#item_parent_type_id', ()->
    $.get('/items/get_children_type', {parent_id: $(this).val()}, (data)->
      $('#item_child_type_id').attr('readonly', false).find('option').remove()
      $.each(data, (idx, e)->
        $('#item_child_type_id').append("<option value=#{e[0]}>#{e[1]}</option>")
      )
    )

  $(document).on 'click', '.submit_btn', (e)->
    e.preventDefault()
    $parent = $('#item_parent_type_id')
    $parent.after("<input type='hidden' name='item[parent_type_name]' value=#{$parent.find('option:selected').text()} />")
    $child = $('#item_child_type_id')
    $child.after("<input type='hidden' name='item[child_type_name]' value=#{$child.find('option:selected').text()} />")
    $(this).parent('form').submit()

  if $('#monthly_chart').length > 0
    set_chart()
