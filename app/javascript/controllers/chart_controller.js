import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  connect() {
    // Declare chart dimensions and margins
    const width = 640;
    const height = 400;
    const marginTop = 20;
    const marginRight = 20;
    const marginBottom = 30;
    const marginLeft = 40;

    // Select container and append one SVG
    const svg = d3.select(this.element)
      .append("svg")
      .attr("width", width)
      .attr("height", height);

    // Declare scales
    const x = d3.scaleUtc()
      .domain([new Date("2025-01-01"), new Date()])
      .range([marginLeft, width - marginRight]);

    const y = d3.scaleLinear()
      .domain([0, 100])
      .range([height - marginBottom, marginTop]);

    // Add x-axis
    svg.append("g")
      .attr("transform", `translate(0,${height - marginBottom})`)
      .call(d3.axisBottom(x));

    // Add y-axis
    svg.append("g")
      .attr("transform", `translate(${marginLeft},0)`)
      .call(d3.axisLeft(y));
  }
}
