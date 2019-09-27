$(function() {
    $.getJSON('/mongo', function(resp){
        setTimeout(function() {
            setUpChart(resp);
            buildTable(resp);
        }, 2000);
    });



    function buildTable(data){
        var rowsDefinition = '';
        $.each(data["servers"], function(idx, item){
            var isOk = item['difference'] == 0;
            var className = isOk ? 'status--process' : 'status--denied';
            var status = isOk? 'OK' : 'Different';
            message = item['difference_desc']
            if (item['difference'] != 0) {
                message = item['difference'] + ' node(s) ' + item['difference_desc'];
            } 
            rowsDefinition += '<tr><td>'+item['name']+'</td>';
            rowsDefinition += '<td class="text-right">'+item['expectedNodes']+'</td>'
            rowsDefinition += '<td class="text-right">'+item['convergedNodes']+'</td>'
            rowsDefinition += '<td>'+message+'</td>';
            rowsDefinition += '<td><span class="'+className+'">'+status+'</span></td></tr>';
        });
        $('#cluster_status tbody').html(rowsDefinition);
    }


    function setUpChart(data) {
        var ctx = document.getElementById("percent-chart1");
    if (ctx) {
      ctx.height = 280;
      var myChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
          datasets: [
            {
              label: "My First dataset",
              data: [6, 2],
              backgroundColor: [
                '#08aa83',
                '#f54652'
              ],
              hoverBackgroundColor: [
                '#08aa83',
                '#f54652'
              ],
              borderWidth: [
                0, 0
              ],
              hoverBorderColor: [
                'transparent',
                'transparent'
              ]
            }
          ],
          labels: [
            'OK',
            'Errored'
          ]
        },
        options: {
          maintainAspectRatio: false,
          responsive: true,
          cutoutPercentage: 60,
          animation: {
            animateScale: true,
            animateRotate: true
          },
          legend: {
            display: true
          },
          tooltips: {
            titleFontFamily: "Poppins",
            xPadding: 15,
            yPadding: 10,
            caretPadding: 0,
            bodyFontSize: 16
          }
        }
      });
    }
    }
});