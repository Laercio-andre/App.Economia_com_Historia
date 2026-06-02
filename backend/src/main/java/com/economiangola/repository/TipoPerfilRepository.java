// src/main/java/com/economiangola/repository/TipoPerfilRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.TipoPerfil;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TipoPerfilRepository extends JpaRepository<TipoPerfil, Long> {

    Optional<TipoPerfil> findByNome(String nome);
}
