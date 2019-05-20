$(function() {
    $.getJSON('/data', function(resp){
        buildTable(resp);
    });



    function buildTable(data){
        var tableDefinition = '<table><tr><th>Server Name</th><th>Expected Nodes</th><th>Nodes Converged</th><th>Difference</th><th>Status</th></tr>';
        $.each(data["servers"], function(idx, item){
            var isOk = item['expectedNodes'] == item['convergedNodes'];
            var className = 'expected';
            var status = 'OK';
            if (!isOk) {
                className = 'difference';
                status = 'Different';
            }
            message = ''
            var difference = item['convergedNodes'] - item['expectedNodes'];
            if (difference > 0) {
                message = difference + ' node(s) extra';
            } 
            else if (difference < 0 ){
                message = Math.abs(difference) + ' node(s) missing';
            }
            else {
                // its 0
                message = 'SAME';
            }
            tableDefinition += '<tr class="'+className+'"><td>'+item['name']+'</td>';
            tableDefinition += '<td>'+item['expectedNodes']+'</td>'
            tableDefinition += '<td>'+item['convergedNodes']+'</td>'
            tableDefinition += '<td>'+message+'</td>';
            tableDefinition += '<td>'+status+'</td></tr>';
        });
        tableDefinition += '</table>';
        $('body').append(tableDefinition);
    }
});