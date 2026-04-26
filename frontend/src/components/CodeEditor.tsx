import CodeMirror from '@uiw/react-codemirror';
import { sql } from '@codemirror/lang-sql';

interface CodeEditorProps {
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
  placeholder?: string;
}

export default function CodeEditor({ value, onChange, disabled = false, placeholder }: CodeEditorProps) {
  return (
    <div className={disabled ? "opacity-75" : ""}>
      <CodeMirror
        value={value}
        height="256px"
        extensions={[sql()]}
        onChange={onChange}
        placeholder={placeholder}
        editable={!disabled}
        className={`border border-gray-300 rounded-lg ${
          disabled ? "bg-gray-100" : ""
        }`}
        style={{
          overflow: 'auto'
        }}
        basicSetup={{
          lineNumbers: true,
          highlightActiveLineGutter: true,
          highlightActiveLine: true,
          foldGutter: true,
        }}
      />
    </div>
  );
}