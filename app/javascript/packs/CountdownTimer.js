'use strict'
import {FetchRequest} from "@rails/request.js";

let rotationValue = [0,0,0,0];

/**
 * Starts the countdown timer.
 * By requesting the due date and then starting a function on an interval timer.
 */
let intervalID =0;
function get_and_set_countdown_timer(){
    let containers = document.getElementsByClassName("countdown-container");
    if(intervalID !== 0){
        clearInterval(intervalID);
    }
    if(containers.length > 0){
        let countdown = containers[0];
        let href = window.location.href+".json";

        get_due_time(href).then(r => {
            intervalID = setInterval(update_counter, 1000, countdown, r);
        });
    }
}

/**
 * Updates the counter every second using:
 * @param countdownContainer the countdown container
 * @param due_time the time the exam is due
 */
function update_counter(countdownContainer, due_time){
    let now = Date.now()
    let diffTime = (due_time-now)/1000;

    let seconds = 0;
    let minutes = 0;
    let hours = 0;
    let days = 0;
    if(diffTime >= 0){
        const divmod = (x, y) => [Math.floor(x / y), x % y];
        [minutes, seconds] = divmod(diffTime,60);
        [hours, minutes] = divmod(minutes, 60);
        [days, hours] = divmod(hours, 24);
        seconds = Math.round(seconds);
    }

    update_sub_counter(0, days, countdownContainer);
    update_sub_counter(1, hours, countdownContainer);
    update_sub_counter(2, minutes, countdownContainer);
    update_sub_counter(3, seconds, countdownContainer);
}

/**
 * Updates the sub counter (e.g. days, hours, minutes and hours of the countdown timer)
 * @param boxNumber The number from (0 to 3) that represents which box to change, the first box is days, the last box is seconds.
 * @param newContent Is the new value to put in the box.
 * @param countdownContainer is the countdown container
 */
function update_sub_counter(boxNumber, newContent, countdownContainer){
    let index = (boxNumber)*2+1;

    let node = countdownContainer.childNodes[index];
    let currentContent = node.childNodes[1].innerText;
    if(currentContent.toString() !== newContent.toString()){

        rotationValue[boxNumber] = rotationValue[boxNumber] + 1;
        console.log(rotationValue[boxNumber])
        node.style.transform = "rotate3d(1,0,0,"+rotationValue[boxNumber]+"turn)";
    }
    node.childNodes[1].innerText = newContent;
}

/**
 * Gets the a url request that returns json which includes the .due attribute
 * @param url URL to fetch
 * @returns {Promise<*|Date>} return the date as a promise
 */
async function get_due_time( url) {
    const request = new FetchRequest('get', url)
    let response = await request.perform()
    if(response.ok){
        try {

            return new Date(Date.parse((await response.json).due))
        }catch(err){
            return err
        }
    }
}

document.addEventListener("turbo:load", () => {
  get_and_set_countdown_timer()
})