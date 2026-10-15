import re

class Token:
    def __init__(self, type_, value):
        self.type = type_
        self.value = value

    def __repr__(self):
        return f"Token({self.type}, '{self.value}')"


class Lexer:
    TOKEN_RULES = [
        ('VOID',     r'\bvoid\b'),                     # Palabra clave void
        ('ID',       r'[a-zA-Z_][a-zA-Z0-9_]*'),       # Nombre de la función
        ('LPAREN',   r'\('),                           # Parentesis izquierdo
        ('RPAREN',   r'\)'),                           # Parentesis derecho
        ('LBRACE',   r'\{'),                           # Llave izquierda
        ('RBRACE',   r'\}'),                           # Llave derecha
        ('SKIP',     r'[ \t\r\n]+'),                   # Espacios e ignorados
        ('MISMATCH', r'.'),                            # Cualquier otro carácter no válido
    ]

    def __init__(self, code):
        self.code = code

    def tokenize(self):
        regex_pattern = '|'.join(f'(?P<{name}>{pattern})' for name, pattern in self.TOKEN_RULES)
        tokens = []
        for match in re.finditer(regex_pattern, self.code):
            kind = match.lastgroup
            value = match.group()
            if kind == 'SKIP':
                continue
            elif kind == 'MISMATCH':
                raise SyntaxError(f"Error Léxico: Carácter no permitido '{value}'")
            tokens.append(Token(kind, value))
        return tokens


#ARBOL DE TOKENS
class TreeNode:
    def __init__(self, name, value=None):
        self.name = name
        self.value = value
        self.children = []

    def add_child(self, child_node):
        self.children.append(child_node)

    def print_tree(self, level=0):
        indent = "  " * level
        val_str = f": {self.value}" if self.value else ""
        print(f"{indent}└── {self.name}{val_str}")
        for child in self.children:
            child.print_tree(level + 1)


#VALIDACION DE LA ESTRUCTURA DE LA FUNCION
class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.pos = 0

    def current_token(self):
        if self.pos < len(self.tokens):
            return self.tokens[self.pos]
        return None

    def match(self, expected_type):
        tok = self.current_token()
        if tok and tok.type == expected_type:
            self.pos += 1
            return tok
        expected = expected_type
        found = tok.type if tok else "FIN_DE_CADENA"
        raise SyntaxError(f"Error Sintáctico: Se esperaba '{expected}', pero se encontró '{found}'")

    def parse_function(self):
        root = TreeNode("DeclaracionFuncion")

        # 1. Palabra clave void
        tok_void = self.match('VOID')
        root.add_child(TreeNode("TipoRetorno", tok_void.value))

        # 2. Nombre de la función
        tok_id = self.match('ID')
        root.add_child(TreeNode("NombreFuncion", tok_id.value))

        # 3. Paréntesis ()
        params_node = TreeNode("Parametros")
        tok_lparen = self.match('LPAREN')
        params_node.add_child(TreeNode("SimboloApertura", tok_lparen.value))
        tok_rparen = self.match('RPAREN')
        params_node.add_child(TreeNode("SimboloCierre", tok_rparen.value))
        root.add_child(params_node)

        # 4. Llaves {}
        body_node = TreeNode("CuerpoFuncion")
        tok_lbrace = self.match('LBRACE')
        body_node.add_child(TreeNode("SimboloApertura", tok_lbrace.value))
        tok_rbrace = self.match('RBRACE')
        body_node.add_child(TreeNode("SimboloCierre", tok_rbrace.value))
        root.add_child(body_node)

        # Verificar que no queden tokens sobrantes al final
        if self.pos < len(self.tokens):
            sobrantes = [t.value for t in self.tokens[self.pos:]]
            raise SyntaxError(f"Error Sintáctico: Tokens no esperados al final -> {sobrantes}")

        return root


def probar_analizador(codigo):
    print(f"\nProcesando: '{codigo}'")
    try:
        # Analizador Léxico
        lexer = Lexer(codigo)
        tokens = lexer.tokenize()
        print(f"Tokens identificados: {tokens}")

        # Validar y Generar Árbol
        parser = Parser(tokens)
        arbol = parser.parse_function()

        print("\n¡Estructura VÁLIDA!")
        print("Árbol de Tokens / Sintáctico:")
        arbol.print_tree()

    except SyntaxError as e:
        print(f"¡Estructura INVÁLIDA! -> {e}")


if __name__ == "__main__":
    # Prueba 1
    probar_analizador("void miFuncion(){}")

    # Prueba 2
    probar_analizador("void calcular{}")

    # Prueba 3
    probar_analizador("void funcion&(){}")