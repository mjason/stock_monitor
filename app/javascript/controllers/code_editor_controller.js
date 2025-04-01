import { Controller } from "@hotwired/stimulus"
import * as monaco from 'monaco-editor';

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
    })

    this.editor.onDidChangeModelContent(() => {
      this.codeTarget.value = this.editor.getValue()
    })

    this.element.closest('form')?.addEventListener('submit', () => {
      this.codeTarget.value = this.editor.getValue()
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
