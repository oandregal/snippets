
function getHTMLCellsFromJavascriptObject(jsobject){
    var keysArray = [];
    var cell = "";
    for (var key in jsobject){
        cell = cell + "<td>" + jsobject[key] + "</td>";
    }
    return cell;
}

function getHTMLRowsFromJavascriptArray(element, index, array){
    rows = rows + "<tr>";
    rows = rows + getHTMLCellsFromJavascriptObject(element);
    rows = rows + "</tr>";
}

function updateTables(){
    var tables = ['general', 'agua'];
    for (var index in tables){
        rows = "";
        $("#"+ tables[index] +" tr:first").siblings().remove();
        mydata.resultados[$("#cb").val()][tables[index]].forEach(getHTMLRowsFromJavascriptArray);
        $("#"+ tables[index] +" tr:first").after(rows);
    }
};

var rows;
updateTables();
$("#cb").change(function(){
    updateTables();
});
