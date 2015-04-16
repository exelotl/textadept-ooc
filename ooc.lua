-- Copyright 2006-2014 Mitchell mitchell.att.foicica.com. See LICENSE.
-- ooc LPeg lexer.
-- Cobbled together from various examples by geckojsc (Jeremy Clarke)

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'ooc'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local sq_str = l.delimited_range("'", true)
local dq_str = l.delimited_range('"', true)
local string = token(l.STRING, sq_str + dq_str)

-- Numbers.
local number = token(l.NUMBER, (l.float + l.integer) * S('LlFfDd')^-1)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
	'class', 'cover', 'extends', 'from', 'func', 'implements', 'interface',
	'operator', 'extend', 'enum', 'get', 'set', 'abstract', 'static',
	'final', 'extern', 'const', 'proto', 'unmangled', 'inline', 'private',
	'protected', 'public', 'internal', 'new', 'this', 'as', 'super', 'break',
	'return', 'continue', 'case', 'if', 'else', 'match', 'while', 'for', 'in',
	'try', 'catch', 'true', 'false', 'null', 'import', 'include', 'use' 
})

-- Types.
local type = token(l.TYPE, word_match{
	'Int', 'Int8', 'Int16', 'Int32', 'Int64', 'Int80', 'Int128',
	'UInt', 'UInt8', 'UInt16', 'UInt32', 'UInt64', 'UInt80', 'UInt128',
	'Octet', 'Short', 'UShort', 'Long', 'ULong', 'LLong', 'ULLong',
	'Float', 'Double', 'LDouble', 'Float32', 'Float64', 'Float128',
	'Char', 'UChar', 'SChar', 'WChar', 'String', 'CString',
	'Void', 'Pointer', 'Bool', 'SizeT', 'This', 'Class', 'Object', 'Func',
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operators.
local operator = token(l.OPERATOR, S('+-/*%<>!=^&|?~:;.()[]{}'))

-- Functions.
local func_call = token(l.FUNCTION, l.word) * #P('(')
local func_def = token(l.FUNCTION, l.word) * ws^0 * P(':') * ws^0 * token(l.KEYWORD, P('func'))
local func = func_call + func_def

-- Classes.
local class_sequence = token(l.CLASS, l.word) * ws^0 * P(':') * ws^0 * token(l.KEYWORD, P('class'))

M._rules = {
	{'whitespace', ws},
	{'class', class_sequence},
	{'keyword', keyword},
	{'type', type},
	{'function', func},
	{'identifier', identifier},
	{'string', string},
	{'comment', comment},
	{'number', number},
	{'operator', operator},
}

M._tokenstyles = {
	annotation = l.STYLE_PREPROCESSOR
}

M._foldsymbols = {
	_patterns = {'[{}]', '/%*', '%*/', '//'},
	[l.OPERATOR] = {['{'] = 1, ['}'] = -1},
	[l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')}
}

return M
