module Microc.Sast where

import           Microc.Ast
import           Data.Text                      ( Text )

type SExpr = (Type, SExpr')
data SExpr' =
    SLiteral Int
  | SFliteral Double
  | SBoolLit Bool
  | SBinop Op SExpr SExpr
  | SUnop Uop SExpr
  | SCall Text [SExpr]
  | SCast Type SExpr
  | LVal LValue
  | SAssign LValue SExpr
  | SNoexpr
  deriving (Show, Eq)

-- | LValues are the class of assignable expressions that can appear
-- on the Left side on the '=' operator
data LValue = SDeref SExpr | SAccess SExpr Int | SId Text
  deriving (Show, Eq)

data SStatement =
    SExpr SExpr
  | SBlock [SStatement]
  | SReturn SExpr
  | SIf SExpr SStatement SStatement
  | SFor SExpr SExpr SExpr SStatement
  | SWhile SExpr SStatement
  deriving (Show, Eq)

data SFunction = SFunction
  { styp  :: Type
  , sname :: Text
  , sformals :: [Bind]
  , slocals :: [Bind]
  , sbody :: SStatement
  }
  deriving (Show, Eq)

type SProgram = ([Struct], [Bind], [SFunction])
