init_data = ()->
  $.ajax
    url: "/items/fetch_data"
    data: {open_id: $('#open_id').val(), month: $("#month").val()}
    success: (data)->
      eval(data)

$ ->
  $(document).on 'touchstart', 'tr.item', ()->
    item_id = $(this).data('id')
    window.location = "/items/#{item_id}/edit"

  if $('#myChart').length > 0
    init_data()

  $(document).on 'touchstart', '.dropdown-menu li', ()->
    $("#month").val($(this).text())
    init_data()
