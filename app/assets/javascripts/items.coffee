init_chart = ()->
  ctx = $("#myChart")

  $.get("/items/fetch_data", {open_id: $('#open_id').val()}, (data)->
    new Chart(ctx,{
      type: 'pie',
      data: {
        labels: ["其他", "餐饮", "购物", "家居", "交通", "休闲"],
        datasets: [
            {
                data: data,
                backgroundColor: ["#d23838", "#cc77b8", "#e8dd23", "#2479d0", "#64d4a3", "#64d1d4"]
            }]
      },
      options: {
        legend: {
          position: 'bottom'
        }
        tooltips: {
          intersect: false,
          displayColors: false
        }
      }
    })
  )

$ ->
  $(document).on 'touchstart', 'tr.item', ()->
    item_id = $(this).data('id')
    window.location = "/items/#{item_id}/edit"

  if $('#myChart').length > 0
    init_chart()
