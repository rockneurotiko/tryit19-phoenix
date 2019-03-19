// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

window.$ = window.jQuery = require("jquery");

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

let board = window.board;


let addTodo = (todo) => {
    if ($(`#${todo.id}`).length == 0) {
        let title = $("<td>").text(todo.title);

        let finished_input = $("<input>", {type: "checkbox", onchange: `toggleTodo("${todo.id}")`});
        let finished = $("<td>").append(finished_input);
        let tr = $("<tr>", {id: todo.id, class: "todo"}).append(title, finished);
        $("#todo-table-body").append(tr);
    } else {
        console.log(`TODO ${todo.id} already exists`);
    }
};

let setTodoFinished = (id, checked) => {
    let input = $(`#${id} > td > input`);
    if (checked === undefined) {
        checked = !input.prop('checked');
    }
    input.prop('checked', checked);
};

window.createTodo = () => {
    let text = $("#create-todo-title").val();
    if (text === "") {
        console.log("EMPTY TITLE");
    } else {
        let data = {title: text};
        $.post(`/api/board/${board}/task`, data)
            .done(function(data) {
                addTodo(data);
                $("#create-todo-title").val("");
            })
            .fail(function() {
                console.log( "error" );
            })
        ;
    }
};



window.toggleTodo = (id) => {
    $.post(`/api/board/${board}/task/${id}/toggle`, {})
        .done(function() {})
        .fail(function() {
            setTodoFinished(id);
        });
};


$("#create-todo-title").keypress(function (e) {
    if (e.which == 13) {
        createTodo();
        return false;
    }
});

// Channel!
import socket from "./socket";

let channel = socket.channel(`board:${board}`, {});

channel.on("create", ({body: todo}) => addTodo(todo));
channel.on("toggle", ({body: todo}) => {
    setTodoFinished(todo.id, todo.finished);
});

channel.join()
    .receive("ok", resp => { console.log(`Board ${board} joined successfully`, resp) })
    .receive("error", resp => { console.log(`Board ${board} unable to join`, resp) });
