from sphinx.highlighting import lexers
from pygments.lexers.web import PhpLexer

def setup(app):
    # Additionnal lexer for inline PHP code blocks.
    lexers['inline-php'] = PhpLexer(startinline=True)

