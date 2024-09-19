import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'hi';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}