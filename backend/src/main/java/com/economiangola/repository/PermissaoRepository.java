// src/main/java/com/economiangola/repository/PermissaoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Permissao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PermissaoRepository extends JpaRepository<Permissao, Long> {

    Optional<Permissao> findByNome(String nome);
}
