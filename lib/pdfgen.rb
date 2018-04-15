# frozen_string_literal: true

require 'open3'
require 'json'

_, status = Open3.capture2('node', '-v')
raise 'This gem requires node be installed and available on the PATH' unless status.success?

MAKE_PDF_COMMAND = File.expand_path('../javascript_bin/make_pdf.js', __FILE__)

class Pdfgen
  def initialize(html)
    @html = html
  end

  def to_pdf(opts = {})
    stdin_data = {opts: opts, html: @html}
    pdf_output, status = Open3.capture2(MAKE_PDF_COMMAND, stdin_data: stdin_data.to_json)
    unless status.success?
      raise 'There was an unknown error running node to create the pdf. Check your logs for output that might assist in debugging.'
    end
    unless pdf_output
      raise 'There was an error creating the temporary file used to pass the HTML to node.'
    end
    pdf_output
  end
end