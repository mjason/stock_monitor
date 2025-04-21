import { Controller } from "@hotwired/stimulus"
import * as monaco from 'monaco-editor';
import {registerCompletion} from 'monacopilot';

import jsonWorker from 'monaco-editor/esm/vs/language/json/json.worker?worker'
import cssWorker from 'monaco-editor/esm/vs/language/css/css.worker?worker'
import htmlWorker from 'monaco-editor/esm/vs/language/html/html.worker?worker'
import jsWorker from 'monaco-editor/esm/vs/language/typescript/ts.worker?worker'
import editorWorker from 'monaco-editor/esm/vs/editor/editor.worker?worker'


// Connects to data-controller="code-editor"
export default class extends Controller {

  static targets = ["editor", "code"]

  static values = {
    language: { type: String, default: "ruby" },
    theme: { type: String, default: "vs-dark" }
  }

  connect() {
    console.log("CodeEditorController connected")
    this.initWorker()
    this.initEditor()
  }

  disconnect() {
    if (this.editor) {
      this.editor.dispose()
    }
  }

  initEditor() {
    this.editor = monaco.editor.create(this.editorTarget, {
      language: this.languageValue,
      automaticLayout: true,
      theme: this.themeValue,
      fontSize: 18,
      value: this.codeTarget.value,
      tabSize: 2,
      insertSpaces: true,
      detectIndentation: false,
      useTabStops: true
    })

    this.editor.onDidChangeModelContent(() => {
      this.codeTarget.value = this.editor.getValue()
    })

    this.element.closest('form')?.addEventListener('submit', () => {
      this.codeTarget.value = this.editor.getValue()
    })
  }

  initCompletion() {
    registerCompletion(monaco, this.editor, {
      language: "ruby",
      endpoint: "/completions",
      requestHandler: async ({endpoint, body}) => {
        const response = await fetch(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify(body)
        });

        const data = await response.json()

        console.log(data)

        // Process and transform the response
        const processedCompletion = data.text
            .trim()
            .replace(/\t/g, '    ') // Convert tabs to spaces

        return {
          completion: processedCompletion,
        }
      }
    })
  }

  initWorker() {
    self.MonacoEnvironment = {
      getWorker: function (workerId, label) {
        switch (label) {
          case 'json':
            return jsonWorker()
          case 'css':
          case 'scss':
          case 'less':
            return cssWorker()
          case 'html':
          case 'handlebars':
          case 'razor':
            return htmlWorker()
          case 'typescript':
          case 'javascript':
            return jsWorker()
          default:
            return editorWorker()
        }
      }
    }
  }
}
