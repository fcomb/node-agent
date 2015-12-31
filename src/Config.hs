{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Config (
    loadConf,
    saveConf,
    Configuration(..)
) where

import Data.Yaml
import Data.Maybe
import GHC.Generics
import Globals
import Control.Lens

data Configuration = Configuration {
    dockerHost  :: String
    , fcombHost :: String
    , nodeId    :: String
    , nodeToken :: String
} deriving Generic

instance ToJSON Configuration
instance FromJSON Configuration


loadConf :: IO (Maybe Configuration)
loadConf = do
    maybeConf <- decodeFile configFilePath :: IO (Maybe Configuration)
    -- todo: error handling
    case maybeConf of
      Nothing -> return Nothing
      Just conf ->
        return $ Just confWithDockerHostWithFcombHost
        where
            confWithDockerHost = if null (dockerHost conf)
                then conf { dockerHost = defaultDockerHost}
                else conf
            confWithDockerHostWithFcombHost = if null (fcombHost conf)
                then conf { fcombHost = defaultFcombHost}
                else conf


saveConf :: Configuration -> IO ()
saveConf conf = encodeFile configFilePath conf
